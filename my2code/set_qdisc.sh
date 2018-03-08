#!/bin/bash

RATE="$1"
QDISC_NAME="$2"
QDISC_PARAMS="$3"
IFACE="$4"
die()
{
	echo "$@" >&2
	exit 1
}

[ -z "$QDISC_NAME" ] && die "Missing qdisc name."

regex='limit ([0-9]+)'

if [[ "$QDISC_NAME" == "pfifo_fast" && "$QDISC_PARAMS" =~ $regex ]]; then
    QDISC_PARAMS=""
    QLEN=${BASH_REMATCH[1]}
else
    QLEN=100
fi

sudo ip link set dev $IFACE qlen $QLEN
sudo tc qdisc del dev $IFACE root 2>/dev/null
sudo tc qdisc add dev $IFACE handle 1: root tbf rate $RATE burst 1514 latency 100ms || exit 1
sudo tc qdisc add dev $IFACE handle 2: parent 1:1 $QDISC_NAME $QDISC_PARAMS || exit 1
