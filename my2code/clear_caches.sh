#!/bin/sh

sudo ip route flush cache || exit 1
ssh server -i ./ssh/id_rsa 'sudo ip route flush cache' || exit 1
exit 0
