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

#set listener for sigterm an other signals in order to de-register from master node.
function cleanup {
	echo "cleaning stuff..."
	$HADOOP_PREFIX/sbin/stop-dfs.sh
	$HADOOP_PREFIX/sbin/stop-yarn.sh
	echo "done!"
}
trap cleanup SIGTERM TERM 15

## configure the hadoop and spark installations
echo " "
echo "Preparing Apache Spark..."
echo " "
sed s/HOSTNAME/$HOSTNAME/ $HADOOP_PREFIX/etc/hadoop/core-site.xml.template > $HADOOP_PREFIX/etc/hadoop/core-site.xml
sed s/HOSTNAME/$HOSTNAME/ $HADOOP_PREFIX/etc/hadoop/yarn-site.xml.template > $HADOOP_PREFIX/etc/hadoop/yarn-site.xml
sed "s/__MASTER__/$HOSTNAME/;s/__HOSTNAME__/$HOSTNAME/;s/__LOCAL_IP__/$IP/" /tmp/spark-files/spark-env.sh.template > $SPARK_HOME/conf/spark-env.sh

sed s/HOSTNAME/$HOSTNAME/ $SPARK_HOME/yarn-remote-client/core-site.xml.template > $SPARK_HOME/yarn-remote-client/core-site.xml
sed s/HOSTNAME/$HOSTNAME/ $SPARK_HOME/yarn-remote-client/yarn-site.xml.template > $SPARK_HOME/yarn-remote-client/yarn-site.xml

echo " "
echo "Starting ssh service..."
echo "***********************"
echo " "
service ssh start

$HADOOP_PREFIX/sbin/stop-dfs.sh
$HADOOP_PREFIX/sbin/stop-yarn.sh

echo " "
echo "Starting Hadoop Namenode..."
echo "***************************"
echo " "
$HADOOP_PREFIX/sbin/start-dfs.sh
sleep 5

echo " "
echo "Starting Hadoop Yarn..."
echo "***********************"
echo " "
$HADOOP_PREFIX/sbin/start-yarn.sh
sleep 5

echo " "
echo "Starting Spark Master..."
echo "************************"
echo " "
$SPARK_HOME/sbin/start-master.sh 

if [[ $1 == "-d" ]]; then
	# this hack will let us listen to SIGTERM and also maintain the process running in the container
	$(while true; do sleep 1000; done) & 
	wait $!
fi

if [[ $1 == "-bash" ]]; then
  	/bin/bash
fi