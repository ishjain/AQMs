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


echo "setting qdisc \"$QD\"-\"$iter\" at routers----------:"
echo "---------------------------------------------------"

#router1
ssh -i ~/.ssh/id_rsa ishjain@pc1.instageni.ku.gpeni.net -p 30099 "cd mycode && sudo ./set_qdisc.sh \"$RATE_UP\" \"$QDISC\" \"$QDISC_ARGS_UP\" \"eth2\"" || exit 1

#router3
ssh -i ~/.ssh/id_rsa ishjain@pc2.instageni.ku.gpeni.net -p 30099 "cd mycode && sudo ./set_qdisc.sh \"$RATE_DOWN\" \"$QDISC\" \"$QDISC_ARGS_DOWN\" \"eth1\"" || exit 1

#router2
ssh -i ~/.ssh/id_rsa ishjain@pc2.instageni.ku.gpeni.net -p 30098 "cd mycode && sudo ./set_delay.sh \"$RTT\"" || exit 1

#ssh server -i ~/.ssh/id_rsa "cd mycode && sudo ./set_cc.sh \"$CC\"" || exit 1
#server


#echo "Now running test on client--------:"

#client
ssh -i ~/.ssh/id_rsa ishjain@pc1.instageni.ku.gpeni.net -p 30098 "cd mycode && sudo bash client_flent.sh \"$QD\", \"$iter\", \"$filename\" &" || exit 1

#sleep 72 #more than 70

exit 0
