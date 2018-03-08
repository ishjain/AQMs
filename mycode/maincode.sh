#!/bin/sh

val=$1 #value can be 1 OR 10 OR 100
scp -r -P 30098 -i ~/.ssh/id_rsa $PWD ishjain@pc1.instageni.ku.gpeni.net:~/ 
scp -r -P 30099 -i ~/.ssh/id_rsa $PWD ishjain@pc1.instageni.ku.gpeni.net:~/ 
scp -r -P 30098 -i ~/.ssh/id_rsa $PWD ishjain@pc2.instageni.ku.gpeni.net:~/ 
scp -r -P 30099 -i ~/.ssh/id_rsa $PWD ishjain@pc2.instageni.ku.gpeni.net:~/ 
scp -r -P 30098 -i ~/.ssh/id_rsa $PWD ishjain@pc3.instageni.ku.gpeni.net:~/ 


#client
ssh -i ~/.ssh/id_rsa ishjain@pc1.instageni.ku.gpeni.net -p 30098 "sudo ip route flush cache" || exit 1

#sudo ip route flush cache
#server
ssh -i ~/.ssh/id_rsa ishjain@pc3.instageni.ku.gpeni.net -p 30098 "sudo ip route flush cache" || exit 1
 
#start netserver at server
ssh -i ~/.ssh/id_rsa ishjain@pc3.instageni.ku.gpeni.net -p 30098 "netserver &" || exit 1


filename=mainfile$val

#client

ssh -i ~/.ssh/id_rsa ishjain@pc1.instageni.ku.gpeni.net -p 30098 "cd mycode && echo \"RTT,Davg,Uavg,Dsum,Usum\"> \"$filename\".csv" || exit 1
#ssh -i ~/.ssh/id_rsa ishjain@pc1.instageni.ku.gpeni.net -p 30098 "cd mycode && touch \"$filename\".csv && rm \"$filename\".csv" || exit 1


bash parameter$val.sh "mainfile$val"

mkdir -p DataDir/parameter$val

scp -r -P 30098 -i ~/.ssh/id_rsa ishjain@pc1.instageni.ku.gpeni.net:~/mycode/filename* $PWD/DataDir/parameter$val
scp -r -P 30098 -i ~/.ssh/id_rsa ishjain@pc1.instageni.ku.gpeni.net:~/mycode/mainfile* $PWD/DataDir/parameter$val
#bash parameter1.sh
