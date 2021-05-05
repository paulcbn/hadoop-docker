# hadoop-docker

This is the candidate release for a docker-compose/docker swarm arch based of nodes of types:
 - namenode
 - node - runs the datanode service and nodemanager service
 - resourcemanager 
 - historyserver

There is a base container like in the https://github.com/big-data-europe/docker-hadoop and https://github.com/asergiu/hadoop-docker project that inspired this development. The base container should be build in the base folder with a command of the type:<br>
<b>docker build [-t repo:tag] . </b>

The docker service option <code>--replicas n</code> should allow basic scalling of the node of the system. Decomissioning of containers should still be done manually.



  
