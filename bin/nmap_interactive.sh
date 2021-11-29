#!/bin/bash
echo -n "Target list (google.com, 192.168.1.1/24): "
read IP

echo "Treat all hosts as online -- skip host discovery (Y/N)?"
read answer
PN=""
if [ "$answer" != "${answer#[Yy]}" ] ; then
    PN="-Pn";
fi

nmap $IP $PN --privileged --min-rtt-timeout 50ms --initial-rtt-timeout 300ms --max-retries 2 --host-timeout 15m -g 53 -p T:80,443,25,135,137,139,445,1433,3306,5432,23,21,22,110,111,2049,3389,8080 -sV -sC -oX step1.xml && nmap --privileged --min-hostgroup 100 --max-hostgroup 1000 --max-rtt-timeout 500ms --min-rtt-timeout 50ms --initial-rtt-timeout 300ms --max-retries 2 -g 53 -p T:0-20,24,26-79,81-109,112-134,136,138,140-442,444,446-1432,1434-2048,2050-3305,3307-3388,3390-5431,5433-8079,8081-29999,U:53,111,137,161,162,500,1434,5060,11211 -sV -sC -oX step2.xml --script targets-xml --script-args newtargets,state=up,iX=step1.xml&& nmap --privileged --min-hostgroup 100 --max-hostgroup 1000 --max-rtt-timeout 500ms --min-rtt-timeout 50ms --initial-rtt-timeout 300ms --max-retries 2 -sV -g 53 -p T:30000-65535,U:67-69,123,135,138,139,445,514,520,631,1434,1900,4500,5353,49152 -oX step3.xml --script targets-xml --script-args newtargets,state=up,iX=step2.xml
