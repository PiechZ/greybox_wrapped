from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from src.database import Database
from src.achievement import Achievement
import pathlib

app = FastAPI()

app.add_middleware(
    CORSMiddleware,
    allow_origins=["http://localhost:3000"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

path_to_db = pathlib.Path(__file__).parent.parent.parent / "data/adk_wrapped.db"
db = Database(path_to_db)

@app.get("/")
def show_instructions():
    return {
        "headline": "Welcome to the ADK Wrapped API",
        "content": "Please find your greybox ID and enter it at /achievements/{greybox_id}",
    }


@app.get("/achievements/{greybox_id}")
def show_achievements(greybox_id: int):
    return db.get_achievements(clovek_id=greybox_id)