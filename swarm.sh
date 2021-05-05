#!/bin/bash

# namenode:
docker service create \
    --mount type=volume,src=namenode_volume,dst=/hadoop-data/dfs/name \
    --name namenode \
    --network my-overlay \
    --endpoint-mode dnsrr \
    --publish published=9870,target=9870,protocol=tcp,mode=host  \
    --publish published=9000,target=9000,protocol=tcp,mode=host  \
    --env CLUSTER_NAME=hadoop \
    --detach=true \
    --env-file hadoop.env \
    paulcbn/hadoop-namenode


# datanode:
docker service create \
    --mount type=volume,src=datanode_volume,dst=/hadoop-data/dfs/data \
    --name datanode \
    --network my-overlay \
    --endpoint-mode dnsrr \
    --env SERVICE_PRECONDITION="namenode:9870 namenode:9000" \
    --env NODE_MANAGER_PRECONDITION="resourcemanager:8088" \
    --env CONTAINER_NAME=container1 \
    --env-file hadoop.env \
    --detach=true \
    paulcbn/hadoop-datanode


# resource manager:
docker service create \
    --mount type=volume,src=datanode_volume,dst=/hadoop-data/dfs/data \
    --name resourcemanager \
    --network my-overlay \
    --endpoint-mode dnsrr \
    --env SERVICE_PRECONDITION="namenode:9870 namenode:9000" \
    --publish published=8088,target=8088,protocol=tcp,mode=host  \
    --env-file hadoop.env \
    --detach=true \
    paulcbn/hadoop-resourcemanager
