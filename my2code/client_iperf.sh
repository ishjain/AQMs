#!/bin/sh

QD="$1"
iter="$2"
filename="$3"

#flent rrul -H server -l 60 -t "filename-$QD-$iter" | tee "filename-$QD-$iter.csv"
 
iperf -c server -t 40 -p 5001 >  "filename-$QD-$iter-1.csv" &
iperf -c server -t 40 -p 5002 >  "filename-$QD-$iter-2.csv" &
iperf -c server -t 40 -p 5003 >  "filename-$QD-$iter-3.csv" &
#iperf -c server -t 40 -p 5004 >  "filename-$QD-$iter-4.csv" & 
#sleep 
sleep 45
#get the median latency and throughput. 
grep "sec" "filename-$QD-$iter-1.csv" | awk -vORS=, '{print $7}' >> "$filename".csv
grep "sec" "filename-$QD-$iter-2.csv" | awk -vORS=, '{print $7}' >> "$filename".csv
grep "sec" "filename-$QD-$iter-3.csv" | awk  '{print $7}' >> "$filename".csv
#grep "MBytes" "filename-$QD-$iter-4.csv" | awk '{print $7}' >> "$filename".csv

#grep "Ping (ms) avg" "filename-$QD-$iter.csv" | awk -vORS=, '{print $6}' >> "$filename".csv
#grep "TCP download avg" "filename-$QD-$iter.csv" | awk -vORS=, '{print $6}' >> "$filename".csv
#grep "TCP upload avg" "filename-$QD-$iter.csv" | awk -vORS=, '{print $6}' >> "$filename".csv
#grep "TCP download sum" "filename-$QD-$iter.csv" | awk -vORS=, '{print $6}' >> "$filename".csv
#grep "TCP upload sum" "filename-$QD-$iter.csv" | awk '{print $6}' >> "$filename".csv
