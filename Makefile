run:
	cd sql_prep && dbt run
backend:
	cd backend && uvicorn src.app:app --reload --port 8765
frontend:
	cd frontend && npm start
setup:
	python -m venv env
	env/Scripts/pip install -r requirements.txt

.PHONY: run backend frontend setup