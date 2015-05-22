## Apache Spark Master Node
#
FROM prodriguezdefino/sparkbase
MAINTAINER prodriguezdefino prodriguezdefino@gmail.com

# Expose TCP ports 7077 8080
EXPOSE 7077 8080

RUN mkdir $SPARK_HOME/spark_master_files
ADD files $SPARK_HOME/spark_master_files
RUN chmod 755 $SPARK_HOME/spark_master_files/run_master_node.sh

RUN rm -rf $SPARK_HOME/work
RUN mkdir -p $SPARK_HOME/work
#RUN chown hdfs.hdfs $SPARK_HOME/work
RUN rm -rf /tmp/spark
RUN mkdir /tmp/spark
#RUN chown hdfs.hdfs /tmp/spark

## this one is for Spark shell logging
RUN rm -rf /var/lib/hadoop/hdfs
RUN mkdir -p /var/lib/hadoop/hdfs
#RUN chown hdfs.hdfs /var/lib/hadoop/hdfs
RUN rm -rf $SPARK_HOME/logs
RUN mkdir -p $SPARK_HOME/logs

## deploy the master files
RUN cp /tmp/spark-files/log4j.properties $SPARK_HOME/conf/

CMD ["/usr/local/spark/spark_master_files/run_master_node.sh", "-d"]
