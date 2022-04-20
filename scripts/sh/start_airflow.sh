#!/bin/bash

airflow connections add 'spark_local' --conn-uri 'spark://admin:***@local'
if [[ $? -eq 0 ]];
then
  airflow db init
fi

if [[ $? -eq 0 ]];
then
  airflow webserver --port 8080 &
  airflow scheduler &
fi
