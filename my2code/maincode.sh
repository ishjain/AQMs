#!/bin/sh

val=$1 #1, OR 10, OR 100


scp -r -P 25370 -i ~/.ssh/id_rsa $PWD ishjain@pc1.instageni.maxgigapop.net:~/ 
scp -r -P 25371 -i ~/.ssh/id_rsa $PWD ishjain@pc1.instageni.maxgigapop.net:~/ 
scp -r -P 25372 -i ~/.ssh/id_rsa $PWD ishjain@pc1.instageni.maxgigapop.net:~/ 
scp -r -P 25373 -i ~/.ssh/id_rsa $PWD ishjain@pc1.instageni.maxgigapop.net:~/ 
scp -r -P 25374 -i ~/.ssh/id_rsa $PWD ishjain@pc1.instageni.maxgigapop.net:~/ 
#sshclient="-i ~/.ssh/id_rsa ishjain@pc1.instageni.ku.gpeni.net -p 30098"
#sshserver="-i ~/.ssh/id_rsa ishjain@pc3.instageni.ku.gpeni.net -p 30098"

sshclient="-i ~/.ssh/id_rsa ishjain@pc1.instageni.maxgigapop.net -p 25370"
sshserver="-i ~/.ssh/id_rsa ishjain@pc1.instageni.maxgigapop.net -p 25374"
echo "client"
ssh $sshclient "sudo ip route flush cache" || exit 1

#sudo ip route flush cache
#server
ssh $sshserver "sudo ip route flush cache" || exit 1
 
#start 4 iperf server at server
echo "hi1"
ssh $sshserver "iperf -s -p 5001 &" > dump.txt || exit 1
echo "hi2"
ssh $sshserver "iperf -s -p 5002 &" > dump.txt|| exit 1
ssh $sshserver "iperf -s -p 5003 &" > dump.txt|| exit 1
#ssh -i ~/.ssh/id_rsa ishjain@pc3.instageni.ku.gpeni.net -p 30098 "iperf -s -p 5004 &" > dump.txt|| exit 1
echo "hi3"

filename=mainfile${val}fair

#client initialize a file
ssh $sshclient "cd my2code && echo \"Mbps1,Mbps2,Mbps3\"> \"$filename\".csv" || exit 1
#ssh -i ~/.ssh/id_rsa ishjain@pc1.instageni.ku.gpeni.net -p 30098 "cd mycode && touch \"$filename\".csv && rm \"$filename\".csv" || exit 1

echo "hi4"


bash "parameter$val".sh "${filename}"




#Get results

mkdir -p DataDir/param$val

#Get data from client
scp -r -P 25370 -i ~/.ssh/id_rsa ishjain@pc1.instageni.maxgigapop.net:~/my2code/mainfile* $PWD/DataDir/param$val
scp -r -P 25370 -i ~/.ssh/id_rsa ishjain@pc1.instageni.maxgigapop.net:~/my2code/filename* $PWD/DataDir/param$val
#scp -r -P 30098 -i ~/.ssh/id_rsa ishjain@pc1.instageni.ku.gpeni.net:~/my2code/alldata* $PWD/DataDir/param$val



#bash parameter1.sh
