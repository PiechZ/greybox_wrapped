from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from src.database import Database
from src.achievement import Achievement
import pathlib

app = FastAPI()

# TODO: Change to dockerized location (/data/adk_wrapped.db)
try:
    path_to_db = pathlib.Path(__file__).parent.parent.parent / "data/adk_wrapped.db"
    db = Database(path_to_db)
except Exception as e:
    db = None

@app.get("/api")
def show_instructions():
    return {
        "headline": "Welcome to the ADK Wrapped API",
        "content": "Please find your greybox ID and enter it at /achievements/{greybox_id}",
    }


@app.get("/api/achievements/{greybox_id}")
def show_achievements(greybox_id: int):
    return db.get_achievements(clovek_id=greybox_id)