#!/bin/bash
qdisc_name_ish=$1
cc_ish=cubic
rtt=50ms
rate_up=10Mbit
rate_down=10Mbit

if ["$(qdisc_name_ish)" = "ared"]; then
	qdisc_name=red
	ared_args_up="min 12500"
	ared_args_down="min 12500"
	qdisc_args="limit 1514000 avpkt 1514 adaptive harddrop"
	qdisc_args_up="${qdisc_args} bandwidth ${rate_up} ${ared_args_up}"
	qdisc_args_down="${qdisc_args} bandwidth ${rate_down} ${ared_args_down}"
	qdisc_label=ared
elif ["$(qdisc_name_ish)" = "fq_codel"]; then
	qdisc_name=fq_codel
	qdisc_args=noecn
	qdisc_args_up=${qdisc_args}
	qdisc_args_down=${qdisc_args}
	qdisc_label=fq_codel
elif ["$(qdisc_name_ish)" = "fq_nocodel"]; then
   qdisc_name=fq_codel
	qdisc_args="limit 127 noecn target 100s"
	qdisc_args_up=${qdisc_args}
	qdisc_label=fq_nocodel
	qdisc_args_up=${qdisc_args}

elif ["$(qdisc_name_ish)" = "codel"]; then
	qdisc_name=codel
	qdisc_args=
	qdisc_args_up=${qdisc_args}
	qdisc_args_down=${qdisc_args}
	qdisc_label=codel
elif ["$(qdisc_name_ish)" = "pie"]; then
	qdisc_name=pie
	qdisc_args=
	qdisc_args_up=${qdisc_args}
	qdisc_args_down=${qdisc_args}
	qdisc_label=pie
elif ["$(qdisc_name_ish)" = "pfifo_fast"]; then
	qdisc_name=pfifo_fast
	qdisc_args="limit 127"
	qdisc_args_up=${qdisc_args}
	qdisc_args_down=${qdisc_args}
	qdisc_label=pfifo_fast
elif ["$(qdisc_name_ish)" = "sfq"]; then	
	qdisc_name=sfq
	qdisc_args=
	qdisc_args_up=${qdisc_args}
	qdisc_args_down=${qdisc_args}
#elif ["$(qdisc_name_ish)" = "ared"]; then
fi
rm mainfile.csv
for i in {1..1}; do  
    #for (( l = ${l_start}; l <=${l_end}; l=l+20/${n_flows} )); do
    
			bash setup_qdiscs.sh ${qdisc_name} "${qdisc_args_down}" "${qdisc_args_up}" ${rate_down} ${rate_up} ${rtt} ${cc_ish} ${i}

    #done
done
