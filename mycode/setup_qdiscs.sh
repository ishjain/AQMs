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
#ssh router1 -i ~/.ssh/id_rsa "cd mycode && sudo ./set_qdisc.sh \"$RATE_UP\" \"$QDISC\" \"$QDISC_ARGS_UP\"" || exit 1
#ssh router3 -i ~/.ssh/id_rsa "cd mycode && sudo ./set_qdisc.sh \"$RATE_DOWN\" \"$QDISC\" \"$QDISC_ARGS_DOWN\"" || exit 1
#ssh router2 -i ~/.ssh/id_rsa "cd mycode && sudo ./set_delay.sh \"$RTT\"" || exit 1
#ssh server -i ~/.ssh/id_rsa "cd mycode && sudo ./set_cc.sh \"$CC\"" || exit 1
#exit 0



if [ "$(hostname --short)" = "client" ]; then
	sudo ./set_cc.sh "$CC"
   echo "START" | netcat router1 8888  # contact router1 for qdiac
   echo "START" | netcat router3 8889  # contact router3 for qdiac
   echo "START" | netcat router2 8890  # contact router2 for delay setup
   echo "START" | netcat server 8891  # contact server for cc setup
   #echo "Sending traffic at rate $l ($i)"
   #rm many_flows.txt
   #for ((j=1; j<=${n_flows}; j++)); do
 
   	#let "port_no = 10000+$j"
   	#echo "-a server -rp $port_no -E $l -e 470 -T UDP -t 100000">>many_flows.txt
   #done
   #ITGSend many_flows.txt -l "sender-$l-$i.log" -x "receiver-$l-$i.log" 
   flent rrul -H server -l 60 | tee "filename-$QD-$iter.csv"
   
   #get the median latency and throughput. 
	grep "Ping (ms) avg" "filename-$QD-$iter.csv" | awk -vORS=, '{print $6}' >> "$filename".csv
	grep "TCP download avg" "filename-$QD-$iter.csv" | awk -vORS=, '{print $6}' >> "$filename".csv
	grep "TCP upload avg" "filename-$QD-$iter.csv" | awk '{print $6}' >> "$filename".csv


elif [ "$(hostname --short)" = "router1" ]; then
   netcat -l 8888  > /dev/null # Wait for contact from client
   #sleep 5
   #bash queuemonitor.sh eth2 90 0.1 > "router-$l-$i.txt"
   echo -n "$QD,$iter,"
   #cd mycode
   sudo bash set_qdisc.sh "$RATE_UP" "$QDISC" "$QDISC_ARGS_UP" eth2
   #cat "router-$l-$i.txt" | \
   #    sed 's/\p / /g' | \
   #   awk  '{ sum += $37 } END { if (NR > 0) print sum / NR }'

elif [ "$(hostname --short)" = "router3" ]; then
   netcat -l 8889  > /dev/null # Wait for contact from client
   echo -n "$QD,$iter,"
	#cd mycode
	sudo bash set_qdisc.sh "$RATE_DOWN" "$QDISC" "$QDISC_ARGS_DOWN" eth1

elif [ "$(hostname --short)" = "router2" ]; then
   netcat -l 8890  > /dev/null # Wait for contact from client
   echo -n "$QD,$iter,"
   #cd mycode
   sudo bash set_delay.sh "$RTT"

elif [ "$(hostname --short)" = "server" ]; then
   netcat -l 8891  > /dev/null # Wait for contact from client
   echo -n "$QD,$iter,"
   #cd mycode
   sudo bash set_cc.sh "$CC"
fi
