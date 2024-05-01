run:
	cd greybox_conversion/transform && dbt run
test:
	cd greybox_conversion/transform && dbt test
build:
	cd greybox_conversion/transform && dbt build
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

.PHONY: run test build backend frontend setup adk logs deploy