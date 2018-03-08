# AQMs in residential setting

A project on active queue management. We implemented 7 queue management schemes including ARED, CoDel, PIE, and SFQ on GENI testbed and analyzed their performances in residential settings

# Run my experiment
Setup the topology of five nodes in a tandem queue manner and rename the nodes as shown.
![topology](https://github.com/ishjain/AQMs/blob/master/topology.png)

Now we will run the experiment. Initially, we will install flent and netperf tools at client and server node.

Open two terminals and ssh to client and server in those terminals. 
```
ssh -i ~/.ssh/id_rsa ishjain@pc1.instageni.ku.gpeni.net -p 25298
```

Install flent on client and server

```
sudo apt-get update
sudo -H pip install --upgrade pip
sudo -H pip install flent
sudo -H pip install matplotlib
```

Also install the netperf on both client and server

```
sudo apt-get install software-properties-common python-software-properties
sudo add-apt-repository multiverse
sudo apt-get update
sudo apt-get install netperf
```
#### Checking the correct installation of flent and netperf.

On server, Run
```
netserver &
```
You can check if the netserver is running or not using the command `ps -ef | grep netserver`

Now, on client start RRUL (real-time response under load) test for 30 sec (flent adds 5 sec at the beginning as well as the end of the specified duration) and save the collected data in `DataDir` directory. Flent also generates an image file for visualization as `image.png`
```
mkdir DataDir
flent rrul -l 20 -H server -D DataDir -o image.png
```
Open a third terminal on your local machine and get the file from the client node using scp e.g.
```
scp -r -P 25298 -i ~/.ssh/id_rsa ishjain@pc1.instageni.ku.gpeni.net:~/image.png .
```
The image.png will look like-

![image](https://github.com/ishjain/AQMs/blob/master/image.png)

> Note that the flent uses four kind of TCP traffic for the RRUL test represented as the following marking in the image- BE is Best Effort, BK is Background, CS5 is Class Selector 5 (video), EF is Expedient Forwarding. These markings are chosen to correspond to the four priority queues in WiFi networks (background, best effort, video and voice). Also, note that the latency is measured as an average of various UDP and ICMP messages.

With this preparation, we will run our experiment. 

## Run the experiment manually

These steps are helpful to understand the details of our implementation and reproduce the results. 

Open five terminals and ssh to client, router1, router2, router3, and server in each terminal.

On router2, setup an RTT of 50 ms: we will set a delay of 25ms for both uplink and downlink traffic using `netem` at interfaces `eth2` and `eth1` respectively. 
```
sudo tc qdisc replace dev eth1 root netem delay 25ms
sudo tc qdisc replace dev eth2 root netem delay 25ms
```
Now we will set queue management schemes on router1 (eth2) for uplink traffic and on router3 (eth1) for downlink traffic.

On router1 run
```
sudo ip link set dev eth2 qlen 100
sudo tc qdisc del dev eth2 root 2>/dev/null
sudo tc qdisc add dev eth2 handle 1: root tbf rate 1Mbit burst 1514 latency 100ms
sudo tc qdisc add dev eth2 handle 2: parent 1:1 $QDISC_NAME $QDISC_PARAMS_UP
```
Replace `$QDISC_NAME` with `codel` and `$QDISC_PARAMS_UP` with `target 13ms` in the above code for running experiment for CoDel AQM.

Similarly, on router3 run the same commands with interface changed to `eth1` and rate changed to `10Mbit`. Additionally, replace `$QDISC_NAME` with `codel` and leave `$QDISC_PARAMS_DOWN` blank `     `  in the following commands. 

```
sudo ip link set dev eth1 qlen 100
sudo tc qdisc del dev eth1 root 2>/dev/null
sudo tc qdisc add dev eth1 handle 1: root tbf rate 10Mbit burst 1514 latency 100ms
sudo tc qdisc add dev eth1 handle 2: parent 1:1 $QDISC_NAME $QDISC_PARAMS_DOWN
```

The above setup was for 1/10 Mbit uplink/downlink link. The experiment can be run similarly for 10/10 Mbit link. The parameters for various qdiscs for these two link setup is provided in this file.

Note: You can check the qdisc status using
```
tc -p -s -d qdisc show dev eth2
```
and delete the qdisc setting using
```
sudo tc qdisc del dev eth2 root
```

#### Now run the RRUL test

On both client and server run once
```
sudo ip route flush cache
```
Start netserver on the server
```
netserver &
```

### Throughput and latency test


### transient analysis test
Start test for 25+10=30sec  
```
flent rrul -H server -l 25 -f csv > "filename-codel-1.csv"
```
Analyse the obtained file

First remove the first three lines of irrelevent data
```
sed -i '1,3d' filename-codel-1.csv
```
The useful columns are `"TCP upload sum"` at `$3`, `"Ping (ms) avg"` at `$8`, and `"TCP download sum"` at `$18`
We evaluate the average upload and download throughput as
```
awk -F"," '{sum=sum+$3}END{if(NR>0) print "Avg Upload Throughput="sum/NR}' filename-codel-1.csv 
awk -F"," '{sum=sum+$18}END{if(NR>0) print "Avg Download Throughput="sum/NR}' filename-codel-1.csv 
```
This gives
  Avg Upload Throughput=0.0250601
  Avg Download Throughput=42.3456
  

<!---
```
grep "Ping (ms) avg" "filename-$QD-$iter.csv" | awk -vORS=, '{print $6}' >> "$filename".csv
```
--->
## Run the experiment using script
Follow these steps to run the experiment

* For RRUL test, go to `mycode` directory and for fairness test go to `my2code` directory
* Modify ish_setup_qdiscs.sh and maincode.sh to update the ssh and scp commands.
* Run  bash maincode.sh 10 (you can change the parameter to 1, or 10, or 100 for 10/1, 10/10. 100/100 links)
* The desired results would be saved in a directory named `DataDir` on local machine. 
* Use Matlab scripts to plot the results. Use rrulTest.m and transiTest.m for RRUL test data. Use fairTest.m for Fairness test data.

## Results


