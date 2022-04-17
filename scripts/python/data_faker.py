import pandas as pd
from faker import Faker
from collections import defaultdict
from sqlalchemy import create_engine
import os

MYSQL_CONN_STRING = os.getenv('MYSQL_CONN_STRING')
MYSQL_DATABASE = os.getenv('MYSQL_DATABASE')
connection_string = MYSQL_CONN_STRING + "/" + MYSQL_DATABASE
engine = create_engine(
    connection_string,
)
dbConnection = engine.connect()
fake = Faker()
range_data = range(1000)

def fake_associado():
    fake_associado = defaultdict(list)
    for _ in range_data:
        fake_associado["nome"].append( fake.first_name() )
        fake_associado["sobrenome"].append( fake.last_name() )
        fake_associado["dt_nasc"].append( fake.date_of_birth(minimum_age=18, maximum_age=100) )
        fake_associado["email"].append( fake.email() )

    df_fake_associado = pd.DataFrame(fake_associado)
    df_fake_associado.to_sql("associado", con=engine, index=False, if_exists='append', chunksize=1000)
    engine.dispose()
    

def fake_conta():
    fake_conta = defaultdict(list)
    account_type_fakes = ['conta_corrente', 'conta_poupaca', 'conta_salario']
    dbConnection = engine.connect()
    for _ in range_data:
        fake_conta["tipo"].append( fake.words(1, account_type_fakes, True) )
        fake_conta["data_criacao"].append( fake.date_time_this_century() )

    df_fake = pd.DataFrame(fake_conta)
    get_pk = pd.read_sql("select id as id_associado from mov_cartoes.associado", dbConnection)
    df_fake_conta = df_fake.join(get_pk, lsuffix='_df_fake', rsuffix='_get_pk')
    df_fake_conta.to_sql("conta", con=engine, index=False, if_exists='append', chunksize=1000)
    engine.dispose()


def fake_cartao():
    fake_cartao = defaultdict(list)
    dbConnection = engine.connect()
    for _ in range_data:
        fake_cartao["num_cartao"].append( fake.credit_card_number() )
        fake_cartao["data_criacao"].append( fake.date_time_this_century() )

    df_fake = pd.DataFrame(fake_cartao)
    get_pk = pd.read_sql("""
    select associado.id as id_associado_cartao,
    concat(associado.nome, " ",associado.sobrenome) as nom_impresso,
    conta.id as id_conta
    from mov_cartoes.associado as associado, mov_cartoes.conta as conta
    where associado.id = conta.id
    """, dbConnection)
    df_fake_cartao = df_fake.join(get_pk, lsuffix='_df_fake', rsuffix='_get_pk')
    df_fake_cartao.to_sql("cartao", con=engine, index=False, if_exists='append', chunksize=1000)
    engine.dispose()

def fake_movimento():
    fake_movimento = defaultdict(list)
    dbConnection = engine.connect()
    type_fakes = ['supermercado', 'eletronicos', 'automotivo', 'construcao', 'viagem']
    for _ in range_data:
        fake_movimento["vlr_transacao"].append( fake.pydecimal(10, 2, positive=True, min_value=1, max_value=10000) )
        fake_movimento["des_transacao"].append( fake.words(1, type_fakes, True) )
        fake_movimento["data_movimento"].append( fake.date_time_this_century() )
    
    df_fake = pd.DataFrame(fake_movimento)
    get_pk = pd.read_sql("select id as id_cartao from mov_cartoes.cartao", dbConnection)
    df_fake_movimento = df_fake.join(get_pk, lsuffix='_df_fake', rsuffix='_get_pk')
    df_fake_movimento.to_sql("movimento", con=engine, index=False, if_exists='append', chunksize=1000)
    engine.dispose()

fake_associado()
fake_conta()
fake_cartao()
fake_movimento()