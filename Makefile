build:
	docker build -t big-data-env .

up:
	docker-compose up

bash:
	docker exec -it hadoop-env /bin/bash

mysql:
	docker exec -it mov_cartoes_db /bin/bash

ddl:
	docker exec -i mov_cartoes_db mysql -u root -p${MYSQL_ROOT_PASSWORD} < ./scripts/sql/mov_cartoes_ddl.sql

prune:
	docker stop hadoop-env
	docker stop mov_cartoes_db
	docker container prune