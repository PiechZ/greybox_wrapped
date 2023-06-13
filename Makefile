ECR_REPO=637364745310.dkr.ecr.eu-central-1.amazonaws.com/greybox-wrapped
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

ecs:
	docker context use default
	docker build -t backend:latest ./backend/
	# TODO: What is the backend server in this deployment and how can I find that out at build time?
	docker build --arg BACKEND_SERVER="http://backend:8765" -t frontend:latest ./frontend/ 
	docker tag backend:latest $(ECR_REPO):backend
	docker tag frontend:latest $(ECR_REPO):frontend
	docker push $(ECR_REPO):backend
	docker push $(ECR_REPO):frontend
	docker context use ecs
	docker compose up -d


.PHONY: run backend frontend setup adk logs deploy ecs

