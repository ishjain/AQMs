#!/bin/sh

echo '-- router1 --'
ssh router1 -i ~/.ssh/id_rsa tc -s qdisc show dev eth2 || exit 1
echo '-- router2 --'
ssh router2 -i ~/.ssh/id_rsa tc -s qdisc || exit 1
echo '-- router3 --'
ssh router3 -i ~/.ssh/id_rsa tc -s qdisc show dev eth1 || exit 1
exit 0
