#!/bin/sh

QDISC="$1"
QDISC_ARGS_DOWN="$2"
QDISC_ARGS_UP="$3"
RATE_DOWN="$4"
RATE_UP="$5"
RTT=$(echo "$6" | sed 's/ms$//')
CC="$7"
iter="$8"
QD="$9" #QDISC_label
filename="${10}"
#sudo ./set_cc.sh "$CC"

#sshclient="-i ~/.ssh/id_rsa ishjain@pc1.instageni.ku.gpeni.net -p 30098"
#sshrouter1="-i ~/.ssh/id_rsa ishjain@pc1.instageni.ku.gpeni.net -p 30099"
#sshrouter2="-i ~/.ssh/id_rsa ishjain@pc2.instageni.ku.gpeni.net -p 30098"
#sshrouter3="-i ~/.ssh/id_rsa ishjain@pc2.instageni.ku.gpeni.net -p 30099"
#sshserver="-i ~/.ssh/id_rsa ishjain@pc3.instageni.ku.gpeni.net -p 30098"

sshclient="-i ~/.ssh/id_rsa ishjain@pc1.instageni.maxgigapop.net -p 25370"
sshrouter1="-i ~/.ssh/id_rsa ishjain@pc1.instageni.maxgigapop.net -p 25371"
sshrouter2="-i ~/.ssh/id_rsa ishjain@pc1.instageni.maxgigapop.net -p 25372"
sshrouter3="-i ~/.ssh/id_rsa ishjain@pc1.instageni.maxgigapop.net -p 25373"
sshserver="-i ~/.ssh/id_rsa ishjain@pc1.instageni.maxgigapop.net -p 25374"

echo "setting qdisc \"$QD\"-\"$iter\" at routers----------:"
echo "---------------------------------------------------"

#router1
ssh $sshrouter1 "cd my2code && sudo ./set_qdisc.sh \"$RATE_UP\" \"$QDISC\" \"$QDISC_ARGS_UP\" \"eth2\"" || exit 1

#echo "test1"
#router3
ssh $sshrouter3 "cd my2code && sudo ./set_qdisc.sh \"$RATE_DOWN\" \"$QDISC\" \"$QDISC_ARGS_DOWN\" \"eth1\"" || exit 1

#echo "test1"
#router2
ssh $sshrouter2 "cd my2code && sudo ./set_delay.sh \"$RTT\"" || exit 1
#echo "test1"
#ssh server -i ~/.ssh/id_rsa "cd my2code && sudo ./set_cc.sh \"$CC\"" || exit 1
#server


echo "Now running test on client--------:"
echo "----------------------------------:"
#client
ssh $sshclient "cd my2code && sudo bash client_iperf.sh \"$QD\", \"$iter\", \"$filename\" &" || exit 1


exit 0
