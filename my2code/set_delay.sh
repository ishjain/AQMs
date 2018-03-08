#!/bin/bash

#exit 0

DELAY="$1"
die()
{
	echo "$@" >&2
	exit 1
}

[ -z "$DELAY" ] && die "Missing delay"
IFACES="eth1 eth2"

if [[ "$DELAY" == "multi" ]]; then
    export MODE=start
    for IFACE in $IFACES; do
      #IFACE=eth2   
		DELAYS=(5ms 25ms 100ms)
		TARGETS=(5001 5002 5003)
		sudo tc qdisc del dev ${IFACE} root
		sudo tc qdisc add dev ${IFACE} root handle 1: prio priomap 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
		for i in $(seq ${#DELAYS[*]}); do
			#echo "$i"
				sudo tc qdisc add dev ${IFACE} parent 1:$[$i] handle $[$i*10+10]: netem delay ${DELAYS[$i-1]}
				sudo tc filter add dev ${IFACE} parent 1:0 protocol ip u32 match ip dport ${TARGETS[$i-1]} 0xffff flowid 1:$[$i]
		done

    done
else

    DELAY_IF=$[$DELAY/2]
     for IFACE in $IFACES; do
       sudo tc qdisc replace dev ${IFACE} root netem delay ${DELAY_IF}ms
     done
#    for PIPE in 110 111; do
#	ipfw pipe $PIPE config delay ${DELAY_IF}ms
#    done
fi
