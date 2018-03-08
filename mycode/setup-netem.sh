#!/bin/bash

IFACE=${IFACE:-"$1"}

[ -n "$IFACE" ] || exit 1
ethtool -K $IFACE tso off gso off gro off


DELAYS=(5ms 25ms 100ms 250ms 25ms)
TARGETS=(10.60.5.1 10.60.5.2 10.60.5.3 10.60.5.4 10.60.4.2)
SRC=10.60.1.1
MODULE=/usr/local/lib/ipfw_mod.ko

[ "$IFACE" == "eth1" ] || exit 0

grep -q ipfw_mod /proc/modules || insmod "$MODULE"

ipfw -f  pipe flush
ipfw -f flush


for i in $(seq ${#DELAYS[*]}); do
    ipfw add $[$i*2] pipe $[$i*2+100] ip from ${TARGETS[$i-1]} to $SRC in
    ipfw add $[$i*2+1] pipe $[$i*2+101] ip from $SRC to ${TARGETS[$i-1]} in
    ipfw pipe  $[$i*2+100] config delay ${DELAYS[$i-1]}
    ipfw pipe  $[$i*2+101] config delay ${DELAYS[$i-1]}
done








exit 0

TC=`which tc`
IP=`which ip`
FARGS="noecn limit 800"
DRRARGS="quantum 100"

if [ "$MODE" == "stop" ]; then
    $TC qdisc del dev $IFACE root 2>/dev/null
    exit 0
fi

NUM=5
DELAYS=(5ms 25ms 100ms 250ms 25ms)
TARGETS=(10.60.5.1 10.60.5.2 10.60.5.3 10.60.5.4 10.60.4.2)
[ "$IFACE" == "eth1" ] && IFACES=(ifb0 ifb1 ifb2 ifb3 ifb1)
[ "$IFACE" == "eth2" ] && IFACES=(ifb4 ifb5 ifb6 ifb7 ifb5)

ethtool -K $IFACE tso off gso off gro off

$TC qdisc del dev $IFACE root 2>/dev/null
#tc -batch <<EOF
$TC qdisc add dev $IFACE root handle 1: htb
#$TC class add dev $IFACE parent 1: classid 1:1 htb rate 1Gbit
#$TC qdisc add dev $IFACE parent 1:1 handle 11: fq_codel $FARGS
for i in $(seq $NUM); do
#    $TC class add dev $IFACE parent 1: classid 1:$[$i+1] htb rate 100Mbit prio 1
#    $TC qdisc add dev $IFACE parent 1:$[$i+1] handle 1$[$i+1]: netem delay ${DELAYS[$i-1]}

    # IP src and dst
    [ "$IFACE" == "eth1" ] && $TC filter add dev $IFACE protocol ip parent 1: prio 1 u32 \
        match ip src ${TARGETS[$i-1]} \
        action mirred egress redirect dev ${IFACES[$i-1]}
    [ "$IFACE" == "eth2" ] && $TC filter add dev $IFACE protocol ip parent 1: prio 1 u32 \
        match ip dst ${TARGETS[$i-1]} \
        action mirred egress redirect dev ${IFACES[$i-1]}

    $TC qdisc replace dev ${IFACES[$i-1]} root netem delay ${DELAYS[$i-1]}
    $IP link set dev ${IFACES[$i-1]} up

    # ICMP ECHO REPLY src and dst
    #$TC filter add dev $IFACE protocol ip parent 1::0 prio 1 u32 \
        #match ip icmp_type 0x00 0xff \
        #match ip src ${TARGETS[$i-1]} flowid 1:$[$i+1]
    #$TC filter add dev $IFACE protocol ip parent 1::0 prio 1 u32 \
        #match ip icmp_type 0x00 0xff \
        #match ip dst ${TARGETS[$i-1]} flowid 1:$[$i+1]

    # TCP src and dst
#    $TC filter add dev $IFACE protocol ip parent 1: prio 1 u32 \
#        match ip protocol 6 0xff \
#        match ip src ${TARGETS[$i-1]} \
#        action mirred egress redirect dev ${IFACES[$i-1]}
#
#    $TC filter add dev $IFACE protocol ip parent 1: prio 1 u32 \
#        match ip protocol 6 0xff \
#        match ip dst ${TARGETS[$i-1]} \
#        action mirred egress redirect dev ${IFACES[$i-1]}
#
#    # UDP src and dst
#    $TC filter add dev $IFACE protocol ip parent 1: prio 1 u32 \
#        match ip protocol 17 0xff \
#        match ip src ${TARGETS[$i-1]} \
#        action mirred egress redirect dev ${IFACES[$i-1]}
#    $TC filter add dev $IFACE protocol ip parent 1: prio 1 u32 \
#        match ip protocol 17 0xff \
#        match ip dst ${TARGETS[$i-1]} \
#        action mirred egress redirect dev ${IFACES[$i-1]}

done
#$TC filter add dev $IFACE protocol ipv6 parent 1: prio 100 u32 match ip protocol 6 0xff flowid 1:2
#$TC filter add dev $IFACE protocol ipv6 parent 1: prio 102 u32 match ip protocol 17 0xff flowid 1:2

#$TC filter add dev $IFACE protocol all parent 1: prio 999 u32 match ip protocol 0 0x00 flowid 1:1
#$TC filter add dev $IFACE protocol ipv6 parent 1: prio 5 u32 match u16 0xfe80 0xffff at 8 flowid 1:1
#$TC filter add dev $IFACE protocol ipv6 parent 1: prio 6 u32 match u16 0xff02 0xffff at 16 flowid 1:1
#$TC filter add dev $IFACE protocol ipv6 parent 1: prio 7 u32 match u16 0xfe80 0xffff at 16 flowid 1:1
#$TC filter add dev $IFACE protocol ipv6 parent 1: prio 8 u32 match u16 0xff02 0xffff at 8 flowid 1:1
