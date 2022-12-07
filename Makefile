DB_URL=postgresql://root:secret@localhost:5433/fund_transfer?sslmode=disable

network:
	docker network create fund-transfer-network

postgres:
	docker run --name postgres --network fund-transfer-network -p 5433:5432 -e POSTGRES_USER=root -e POSTGRES_PASSWORD=secret -d postgres:14-alpine

createdb:
	docker exec -it postgres createdb --username=root --owner=root fund_transfer

dropdb:
	docker exec -it postgres dropdb fund_transfer

migrateup:
	migrate -path db/migration -database "$(DB_URL)" -verbose up

migratedown:
	migrate -path db/migration -database "$(DB_URL)" -verbose down

sqlc:
	sqlc generate

.PHONY: network postgres createdb dropdb migrateup migratedown sqlc

