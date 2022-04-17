from pyspark.sql import SparkSession
import os

MYSQL_ROOT_PASSWORD = os.getenv('MYSQL_ROOT_PASSWORD')
SPARK_VERSION = os.getenv('SPARK_VERSION')
MYSQL_PYSPARK_CONN_STRING = os.getenv('MYSQL_PYSPARK_CONN_STRING')

spark = (
  SparkSession
  .builder
  .appName("agg_cartoes")
  .getOrCreate()
  )

df = (
  spark.read.format("jdbc")
  .option("url", f"{MYSQL_PYSPARK_CONN_STRING}/mov_cartoes")
  .option("driver", "com.mysql.cj.jdbc.Driver")
  .option("dbtable", "associado")
  .option("user", "root")
  .option("password", MYSQL_ROOT_PASSWORD)
  .load()
  )

df.show()