#!/bin/bash

echo " "
echo " "
echo "****************************"
echo "* Apache Spark Master Node *"
echo "****************************"
echo " "

echo " "
echo "Environment Variables: "
echo " "
env

IP=$(ip -o -4 addr list eth0 | perl -n -e 'if (m{inet\s([\d\.]+)\/\d+\s}xms) { print $1 }')
echo " "
echo "MASTER_IP=$IP"
echo " "

echo " "
echo "Preparing Apache Spark..."
echo " "
## configure the hadoop and spark installations
sed s/HOSTNAME/$IP/ /usr/local/hadoop/etc/hadoop/core-site.xml.template > $HADOOP_PREFIX/etc/hadoop/core-site.xml
sed -i s/__MASTER__/master/ /tmp/spark-files/spark-env.sh.template > $SPARK_HOME/conf/spark-env.sh

echo " "
echo "Starting ssh service..."
echo " "
service ssh start
sleep 2

echo " "
echo "Starting Hadoop Namenode..."
echo " "
$HADOOP_PREFIX/sbin/start-dfs.sh
$HADOOP_PREFIX/sbin/start-yarn.sh

echo " "
echo "Starting Spark Master..."
echo " "
$SPARK_HOME/sbin/start-master.sh 

if [[ $1 == "-d" ]]; then
  while true; do sleep 1000; done
fi

if [[ $1 == "-bash" ]]; then
  /bin/bash
fi