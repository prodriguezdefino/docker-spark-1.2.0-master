## Apache Spark Master node image for Docker

Based on [prodriguezdefino/spark-base](https://github.com/prodriguezdefino/docker-spark-base) image. 

Build the image using ```docker build -t <image-name> .``` with the Dockerfile in the current directory. Later this container will can be started up using ```docker run -itd <image-name>```.

After start up the container will load up a ResourceManager, a NodeManager, a Datanode and a Namenode (with its secondary one too). Then the Spark master process will be started and will wait for connections.

If we configure the redirection of ports 50070 and 8080 then we'll have access to the Hadoop dfs health web page and also the master page of the Spark cluster. To add the redirection just run the container with the ```-p <host_port:cont_port>``` configuration (one per port to map).

