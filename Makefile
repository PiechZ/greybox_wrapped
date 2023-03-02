run:
	uvicorn adk_wrapped.app:app --reload --port 8765
setup:
	python3.10.exe -m venv env
	env/Scripts/pip install -r requirements.txt
	env/Scripts/dbt init sql_prep