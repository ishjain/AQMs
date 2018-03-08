#!/bin/sh

CC="$1"

echo "$CC" > /proc/sys/net/ipv4/tcp_congestion_control
