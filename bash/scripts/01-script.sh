#!/bin/bash

export STAT=/tmp/stat.txt
export LOG=/tmp/access.log

function parse_hour_access_log {
    echo "Web server statistic" > $STAT
    echo "______________________" >> $STAT
    cat $LOG | awk -F: -v hour="$(date +%H)" '{if ($2==int(hour)) print $0}' > /tmp/access_hour.log
    cat /tmp/access_hour.log | awk 'BEGIN {print "TIME RANGE: "} FNR==1 {print $4} END {print $4}' >> $STAT
    sed -i 's/\[//g' $STAT
    echo "______________________" >> $STAT
}

function topIP {
    echo "______________________" >> $STAT
    cat /tmp/access_hour.log | awk '{print $1}' | sort | uniq -c | sort -r | head -n 10 | awk '{ print "Count_Request: " $1 "\tIP_address:" $2 }' >> $STAT
    echo "______________________" >> $STAT
}

function topRequests {
    echo "______________________" >> $STAT
    cat /tmp/access_hour.log | awk '{print $7}' | sort | uniq -c | sort -r | head -n 10 | awk '{ print "Count_Request: " $1 "\tRequest:" $2 }' >> $STAT
    echo "______________________" >> $STAT
}

function allErrors {
    echo "______________________" >> $STAT
    cat /tmp/access_hour.log | awk '($9 !~ /200|301/) && $6 ~ /GET|POST|HEAD/' | awk '{ print "IP_address: " $1 "\tError:" $9}' >> $STAT
    echo "______________________" >> $STAT
}

function allExitStatus {
    echo "______________________" >> $STAT
    cat /tmp/access_hour.log | awk '{print $9}' | sort | uniq -c | sort -rn | awk '{ print "Count_Request: " $1 "\tExitStatus:" $2 }' >> $STAT
    echo "______________________" >> $STAT
}

function sendStats {
    mail "Web server statistic" root@localhost < $STAT
}

parse_hour_access_log
topIP
topRequests
allErrors
allExitStatus
sendStats