#!/bin/bash

/etc/init.d/ssh start

$HADOOP_HOME/bin/hadoop namenode -format
$HADOOP_HOME/sbin/start-dfs.sh
$HADOOP_HOME/sbin/start-yarn.sh
$HADOOP_HOME/sbin/hadoop-daemon.sh start namenode
$HADOOP_HOME/sbin/hadoop-daemon.sh start datanode
$HADOOP_HOME/sbin/yarn-daemon.sh start resourcemanager
$HADOOP_HOME/sbin/yarn-daemon.sh start nodemanager
$HADOOP_HOME/sbin/mr-jobhistory-daemon.sh start historyserver

hdfs dfs -mkdir /mov_cartoes_flat
hdfs dfs -chmod g+w /mov_cartoes_flat

/bin/bash /scripts/sh/start_airflow.sh

tail -f /dev/null