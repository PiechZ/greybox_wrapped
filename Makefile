run:
	cd sql_prep && dbt run
test:
	cd sql_prep && dbt test
adk:
	docker-compose up -d
logs:
	docker-compose logs -f
backend:
	cd backend && uvicorn src.app:app --reload --port 8765
frontend:
	cd frontend && npm start
setup:
	python -m venv env
	env/Scripts/pip install -r requirements.txt
deploy:
	fly deploy backend/
	fly deploy frontend/
	echo "You need to manually deploy the database."

.PHONY: run backend frontend setup adk logs deploy
