#!/bin/bash
#qdisc_name_ish=$1



cc_ish=cubic
rtt=multi
rate_up=10Mbit
rate_down=10Mbit

filename=$1

#if [ "$(hostname --short)" = "client" ]; then
#	rm "$filename".csv #The results are appended in this file
#fi
#arr=("ared","fq_codel","fq_nocodel","codel","pie","Pfifo_fast","sfq")
for i in {1..5}; do  ##Number of iterations=5
    #for (( l = ${l_start}; l <=${l_end}; l=l+20/${n_flows} )); do
    #for qdisc_name_ish in "${arr[@]}"; do
    for j in {1..7}; do ####Total algorithms = 7
		if (($j == 1)); then
			qdisc_name=red
			ared_args_up="min 12500"
			ared_args_down="min 12500"
			qdisc_args="limit 1514000 avpkt 1514 adaptive harddrop"
			qdisc_args_up="${qdisc_args} bandwidth ${rate_up} ${ared_args_up}"
			qdisc_args_down="${qdisc_args} bandwidth ${rate_down} ${ared_args_down}"
			qdisc_label=ared
		elif (($j == 2)); then
			qdisc_name=fq_codel
			qdisc_args=noecn
			qdisc_args_up=${qdisc_args}
			qdisc_args_down=${qdisc_args}
			qdisc_label=fq_codel
		elif (($j == 3)); then
			qdisc_name=fq_codel
			qdisc_args="limit 127 noecn target 100s"
			qdisc_args_up=${qdisc_args}
			qdisc_label=fq_nocodel
			qdisc_args_down=${qdisc_args}

		elif (($j == 4)); then
			qdisc_name=codel
			qdisc_args=
			qdisc_args_up=${qdisc_args}
			qdisc_args_down=${qdisc_args}
			qdisc_label=codel
		elif (($j == 5)); then
			qdisc_name=pie
			qdisc_args=
			qdisc_args_up=${qdisc_args}
			qdisc_args_down=${qdisc_args}
			qdisc_label=pie
		elif (($j == 6)); then
			qdisc_name=pfifo_fast
			qdisc_args="limit 127"
			qdisc_args_up=${qdisc_args}
			qdisc_args_down=${qdisc_args}
			qdisc_label=pfifo_fast

		elif (($j == 7)); then	
			qdisc_name=sfq
			qdisc_args=
			qdisc_args_up=${qdisc_args}
			qdisc_args_down=${qdisc_args}
			qdisc_label=sfq
		fi
		#echo "hi1"
		bash ish_setup_qdiscs.sh ${qdisc_name} "${qdisc_args_down}" "${qdisc_args_up}" ${rate_down} ${rate_up} ${rtt} ${cc_ish} ${i} "${qdisc_label}" "${filename}"

    done
done

