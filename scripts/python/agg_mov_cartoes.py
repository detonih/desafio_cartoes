from pyspark.sql import SparkSession
import pyspark.sql.functions as F
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
spark.conf.set("mapreduce.fileoutputcommitter.marksuccessfuljobs", "false")

df_associado = (
  spark.read.format("jdbc")
  .option("url", f"{MYSQL_PYSPARK_CONN_STRING}/mov_cartoes")
  .option("driver", "com.mysql.cj.jdbc.Driver")
  .option("dbtable", "associado")
  .option("user", "root")
  .option("password", MYSQL_ROOT_PASSWORD)
  .load()
  )

df_conta = (
  spark.read.format("jdbc")
  .option("url", f"{MYSQL_PYSPARK_CONN_STRING}/mov_cartoes")
  .option("driver", "com.mysql.cj.jdbc.Driver")
  .option("dbtable", "conta")
  .option("user", "root")
  .option("password", MYSQL_ROOT_PASSWORD)
  .load()
  )

df_cartao = (
  spark.read.format("jdbc")
  .option("url", f"{MYSQL_PYSPARK_CONN_STRING}/mov_cartoes")
  .option("driver", "com.mysql.cj.jdbc.Driver")
  .option("dbtable", "cartao")
  .option("user", "root")
  .option("password", MYSQL_ROOT_PASSWORD)
  .load()
  .withColumnRenamed('id_associado_cartao', 'id_associado')
  )

df_movimento = (
  spark.read.format("jdbc")
  .option("url", f"{MYSQL_PYSPARK_CONN_STRING}/mov_cartoes")
  .option("driver", "com.mysql.cj.jdbc.Driver")
  .option("dbtable", "movimento")
  .option("user", "root")
  .option("password", MYSQL_ROOT_PASSWORD)
  .load()
  )

df = (
  df_associado
  .withColumnRenamed('id', 'id_associado')
  .join(df_conta, ['id_associado'], 'left')
  .withColumnRenamed('id', 'id_conta')
  .withColumnRenamed('data_criacao', 'data_criacao_conta')
  .withColumnRenamed('nome', 'nome_associado')
  .withColumnRenamed('sobrenome', 'sobrenome_associado')
  .withColumnRenamed('tipo', 'tipo_conta')
  .withColumn('idade_associado', F.floor(F.datediff(F.current_date(), F.to_date(F.col('dt_nasc'), 'yyyy-MM-dd'))/365.25))
  .drop('dt_nasc')
  .drop('email')
  .join(df_cartao, ['id_conta', 'id_associado'], 'left')
  .withColumnRenamed('num_cartao', 'numero_cartao')
  .withColumnRenamed('nom_impresso', 'nome_impresso_cartao')
  .withColumnRenamed('data_criacao', 'data_criacao_cartao')
  .withColumnRenamed('id', 'id_cartao')
  .join(df_movimento, ['id_cartao'], 'left')
  .withColumnRenamed('vlr_transacao', 'vlr_transacao_movimento')
  .withColumnRenamed('des_transacao', 'des_transacao_movimento')
  .drop('id_cartao')
  .drop('id_conta')
  .drop('id_associado')
  .drop('id')
  )

(
  df
  .repartition(1)
  .write
  .csv('/mov_cartoes_flat/', mode='overwrite', header=True)
)
