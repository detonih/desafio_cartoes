#!/bin/bash

spark-submit \
--master local[*] \
--deploy-mode client \
--jars /opt/spark-${SPARK_VERSION}-bin-hadoop2.7/jars/mysql-connector-java-8.0.21.jar \
--driver-class-path /opt/spark-${SPARK_VERSION}-bin-hadoop2.7/jars/mysql-connector-java-8.0.21.jar \
/scripts/python/agg_mov_cartoes.py