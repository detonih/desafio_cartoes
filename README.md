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

## Execução dos scripts de fluxo de trabalho

```
make bash
airflow tasks run submit_agg_mov_cartoes
```

## Acessar o Web UI do AirFLow
[AirFlow Web UI](http://localhost:8080/)