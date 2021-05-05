#!/bin/bash

echo '--- Start node config ---'

env HDFS_CONF_dfs_datanode_data_dir="file:///hadoop-data/dfs/data/$CONTAINER_NAME"

datadir=`echo $HDFS_CONF_dfs_datanode_data_dir | perl -pe 's#file:///##'`
mkdir $datadir

if [ ! -d $datadir ]; then
  echo "Datanode data directory not found: $datadir"
  exit 2
fi
echo "Datanode dir: $HDFS_CONF_dfs_datanode_data_dir"

echo '--- Done node config ---'

echo '--- Start hdfs proces ---'

$HADOOP_HOME/bin/hdfs --config $HADOOP_CONF_DIR datanode &

function wait_for_it()
{
    local serviceport=$1
    local service=${serviceport%%:*}
    local port=${serviceport#*:}
    local retry_seconds=5
    local max_try=100
    let i=1

    nc -z $service $port
    result=$?

    until [ $result -eq 0 ]; do
      echo "[$i/$max_try] check for ${service}:${port}..."
      echo "[$i/$max_try] ${service}:${port} is not available yet"
      if (( $i == $max_try )); then
        echo "[$i/$max_try] ${service}:${port} is still not available; giving up after ${max_try} tries. :/"
        exit 1
      fi
      
      echo "[$i/$max_try] try in ${retry_seconds}s once again ..."
      let "i++"
      sleep $retry_seconds

      nc -z $service $port
      result=$?
    done
    echo "[$i/$max_try] $service:${port} is available."
}

for i in ${NODE_MANAGER_PRECONDITION[@]}
do
    wait_for_it ${i}
done

echo '--- Start nodemanager process ---'
$HADOOP_HOME/bin/yarn --config $HADOOP_CONF_DIR nodemanager



