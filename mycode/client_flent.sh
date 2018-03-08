#!/bin/sh

QD="$1"
iter="$2"
filename="$3"


#flent rrul -H server -l 25 -t "filename-$QD-$iter" -f csv > "filename-$QD-$iter.csv"






flent rrul -H server -l 25 -t "filename-$QD-$iter" | tee "filename-$QD-$iter.csv"
   
#get the median latency and throughput. 
grep "Ping (ms) avg" "filename-$QD-$iter.csv" | awk -vORS=, '{print $6}' >> "$filename".csv
grep "TCP download avg" "filename-$QD-$iter.csv" | awk -vORS=, '{print $6}' >> "$filename".csv
grep "TCP upload avg" "filename-$QD-$iter.csv" | awk -vORS=, '{print $6}' >> "$filename".csv
grep "TCP download sum" "filename-$QD-$iter.csv" | awk -vORS=, '{print $6}' >> "$filename".csv
grep "TCP upload sum" "filename-$QD-$iter.csv" | awk '{print $6}' >> "$filename".csv
