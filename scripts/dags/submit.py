from datetime import datetime
from airflow.models import DAG
from airflow.providers.apache.spark.operators.spark_submit import SparkSubmitOperator

args = {
    'owner': 'Airflow',
}

with DAG(
    dag_id='submit_agg_mov_cartoes',
    default_args=args,
    schedule_interval=None,
    start_date=datetime(2022, 4, 20),
    catchup=False,
    tags=['cartoes'],
) as dag:

    submit_job = SparkSubmitOperator(
        application="/scripts/python/agg_mov_cartoes.py",
        jars="/opt/spark-${SPARK_VERSION}-bin-hadoop2.7/jars/mysql-connector-java-8.0.21.jar",
        driver_class_path="/opt/spark-${SPARK_VERSION}-bin-hadoop2.7/jars/mysql-connector-java-8.0.21.jar",
        task_id="submit_job",
        conn_id='spark_local'
    )
    