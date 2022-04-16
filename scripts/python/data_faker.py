import pandas as pd
from faker import Faker
from collections import defaultdict
from sqlalchemy import create_engine
import os

MYSQL_CONN_STRING = os.getenv('MYSQL_CONN_STRING')
MYSQL_DATABASE = os.getenv('MYSQL_DATABASE')
connection_string = MYSQL_CONN_STRING + "/" + MYSQL_DATABASE
engine = create_engine(
    connection_string
)
dbConnection    = engine.connect()
fake = Faker()
range_data = range(1000)

def fake_associado():
    fake_associado = defaultdict(list)
    for i in range_data:
        fake_associado["nome"].append( fake.first_name() )
        fake_associado["sobrenome"].append( fake.last_name() )
        fake_associado["dt_nasc"].append( fake.date_of_birth() )
        fake_associado["email"].append( fake.email() )

    df_fake_associado = pd.DataFrame(fake_associado)

    df_fake_associado.to_sql("associado", con=engine, index=False, if_exists='append', chunksize=1000)

def fake_conta():
    fake_conta = defaultdict(list)
    account_type_fakes = ['conta_corrente', 'conta_poupaca', 'conta_salario']
    for i in range_data:
        fake_conta["tipo"].append( fake.words(1, account_type_fakes, True) )
        fake_conta["data_criacao"].append( fake.date_this_century() )

    df_fake = pd.DataFrame(fake_conta)
    get_pk = pd.read_sql("select id as id_associado from mov_cartoes.associado", dbConnection)
    df_fake_conta = df_fake.join(get_pk, lsuffix='_df_fake', rsuffix='_get_pk')

    df_fake_conta.to_sql("conta", con=engine, index=False, if_exists='append', chunksize=1000)

fake_conta()