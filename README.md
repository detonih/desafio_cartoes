# Movimentação de Cartões de Crédito

## Download

```
git clone https://github.com/detonih/desafio_cartoes.git
```

## Build da imagem

```
make build
```

## Criação dos serviços em contêineres

```
make up
```

## Exclusão dos serviços em contêineres

```
make prune
```

## Acesso à linha de comando do serviço principal

```
make bash
```

## Criar um usuario e senha para acesso ao AirFlow
#### Utilize o usuário "admin", pois um 'connection id' foi criado especificamente para ele
```
make bash
airflow users create \
    --username admin \
    --firstname Peter \
    --lastname Parker \
    --role Admin \
    --email spiderman@superhero.org
```

## Acessar o Web UI do AirFLow para 'triggar' ou 'schedular' a DAG
#### Nome da dag: submit_agg_mov_cartoes
[AirFlow Web UI](http://localhost:8080/)


## Execução do script de agregação a partir da linha de comando
#### Acesse a linha de comando do serviço principal
```
sh /scripts/sh/launch_agg_mov_cartoes.sh
```

## Verificar o arquivo CSV gravado no HDFS
#### Acesse a linha de comando do serviço principal
```
hdfs dfs -ls /mov_cartoes_flat/
```
