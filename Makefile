run:
	uvicorn backend.app:app --reload --port 8765
setup:
	python -m venv env
	env/Scripts/pip install -r requirements.txt
