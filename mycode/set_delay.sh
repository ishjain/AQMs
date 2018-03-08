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
        export IFACE
        /usr/local/sbin/setup-netem.sh
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
