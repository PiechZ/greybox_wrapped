build:
	docker compose -f docker-compose.data_prep.yml run --build meltano run dbt-duckdb:build

ingest:
	docker compose -f docker-compose.data_prep.yml down || true
	docker volume rm greybox_wrapped_mysql_storage || true
	docker compose -f docker-compose.data_prep.yml up --build --abort-on-container-exit

adk:
	docker-compose -f docker-compose.app.yml up -d
logs:
	docker-compose -f docker-compose.app.yml logs -f
backend:
	cd backend && uvicorn src.app:app --reload --port 8765
frontend:
	cd frontend && npm start
setup:
	python -m venv env
	env/Scripts/pip install -r requirements.txt
	pre-commit install
deploy:
	fly deploy backend/
	fly deploy frontend/
	echo "You need to manually deploy the database."

.PHONY: run test build ingest backend frontend setup adk logs deploy
