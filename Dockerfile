FROM ubuntu:18.04

RUN apt-get update && apt-get install -y --no-install-recommends \
      openjdk-8-jdk \
      net-tools \
      curl \
      netcat \
      gnupg \
      libsnappy-dev \
      openssh-server \
      vim \
      nano \
      unzip \
      wget \
      rsync \
      zip \
      git \
    && rm -rf /var/lib/apt/lists/*
      
ENV JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64/

##HADOOP
ENV HADOOP_VERSION=2.7.2
ENV HADOOP_URL https://archive.apache.org/dist/hadoop/common/hadoop-$HADOOP_VERSION/hadoop-$HADOOP_VERSION.tar.gz

RUN set -x \
    && curl -fSL "$HADOOP_URL" -o /tmp/hadoop.tar.gz \
    && tar -xvf /tmp/hadoop.tar.gz -C /opt/ \
    && rm /tmp/hadoop.tar.gz*

ENV HADOOP_HOME=/opt/hadoop-$HADOOP_VERSION
ENV HADOOP_CONF_DIR=$HADOOP_HOME/etc/hadoop
ENV HADOOP_MAPRED_HOME=$HADOOP_HOME
ENV HADOOP_COMMON_HOME=$HADOOP_HOME
ENV HADOOP_HDFS_HOME=$HADOOP_HOME
ENV YARN_HOME=$HADOOP_HOME
ENV HADOOP_COMMON_LIB_NATIVE_DIR=$HADOOP_HOME/lib/native
ENV HADOOP_OPTS="$HADOOP_OPTS -Djava.library.path=$HADOOP_HOME/lib/native"

COPY config/core-site.xml $HADOOP_HOME/etc/hadoop/
COPY config/hdfs-site.xml $HADOOP_HOME/etc/hadoop/
COPY config/mapred-site.xml $HADOOP_HOME/etc/hadoop/
COPY config/yarn-site.xml $HADOOP_HOME/etc/hadoop/

##SPARK
ENV SPARK_VERSION=3.1.2
ENV SPARK_URL=https://www.apache.org/dist/spark/spark-$SPARK_VERSION/spark-$SPARK_VERSION-bin-hadoop2.7.tgz 
RUN set -x \
    && curl -fSL "$SPARK_URL" -o /tmp/spark.tar.gz \
    && tar -xvf /tmp/spark.tar.gz -C /opt/ \
    && rm /tmp/spark.tar.gz*
ENV SPARK_HOME=/opt/spark-$SPARK_VERSION-bin-hadoop2.7
ENV PYSPARK_PYTHON=python3.6

##MYSQL Connector
RUN set -x \  
    && curl -fSL https://downloads.mysql.com/archives/get/p/3/file/mysql-connector-java-8.0.21.tar.gz -o /tmp/mysql-connector-java-8.0.21.tar.gz \
    && tar -xvf /tmp/mysql-connector-java-8.0.21.tar.gz -C /tmp/ \
    && mv /tmp/mysql-connector-java-8.0.21/mysql-connector-java-8.0.21.jar ${SPARK_HOME}/jars \
    && rm -r /tmp/mysql-connector-java-8.0.21 \
    && rm /tmp/mysql-connector-java-8.0.21.tar.gz

##PYTHON
ENV PYTHON_VERSION=3.6
RUN apt-get update && apt-get install -y --no-install-recommends \
	python${PYTHON_VERSION} \
	python${PYTHON_VERSION}-dev \
	python3-pip \
	python${PYTHON_VERSION}-venv
RUN python${PYTHON_VERSION} -m pip install pip --upgrade
RUN python${PYTHON_VERSION} -m pip install wheel
RUN pip install setuptools
RUN pip install pandas
RUN pip install pyspark
RUN pip install sqlalchemy
RUN pip install pymysql
RUN pip install Faker
RUN pip install cryptography
ADD constraint.txt /constraint.txt
RUN pip install apache-airflow==2.1.4 --constraint ./constraint.txt
RUN pip install apache-airflow-providers-apache-spark

ENV PATH $PATH:$HADOOP_HOME/bin:$SPARK_HOME/bin
ENV HADOOP_CLASSPATH=$HADOOP_CLASSPATH

RUN \
  ssh-keygen -t rsa -P '' -f ~/.ssh/id_rsa && \
  cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys && \
  chmod 0600 ~/.ssh/authorized_keys

COPY config/env.sh /tmp/env.sh
RUN chmod a+x /tmp/env.sh
RUN /tmp/env.sh
RUN rm -f /tmp/env.sh

RUN mkdir /scripts
RUN mkdir /mov_cartoes_flat
RUN mkdir -p /root/airflow/dags

ADD start.sh /start.sh
RUN chmod a+x /start.sh

CMD ["sh", "-c", "/start.sh"]