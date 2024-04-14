from fastapi import FastAPI
from src.database import Database
import pandas as pd
import pathlib

app = FastAPI()

# TODO: Change to dockerized location (/data/adk_wrapped.db)
try:
    path_to_db = pathlib.Path(__file__).parent.parent.parent / "data/adk_wrapped.db"
    db = Database(path_to_db)
except Exception:
    db = None

path_to_rainbow_table = (
    pathlib.Path(__file__).parent.parent.parent / "data/rainbow_table.csv"
)
if path_to_rainbow_table.exists():
    rt = pd.read_csv(path_to_rainbow_table, dtype=str)
else:
    rt = None


@app.get("/api")
def show_instructions():
    return {
        "headline": "Welcome to the ADK Wrapped API",
        "content": "Please go to Greybox 2.0 and look up your individual link to use at /api/link/{id_hash}",
    }


@app.get("/api/achievements/{greybox_id}")
def show_achievements(greybox_id: int):
    return db.get_achievements(clovek_id=greybox_id)


@app.get("/api/link/{id_hash}")
def get_achievements_from_hash(id_hash: str):
    if rt is None:
        return {"error": "Rainbow table not found. Please contact the administrator."}
    else:
        try:
            greybox_id = rt.loc[rt["hash"] == id_hash, "greybox_id"].values[0]
            return db.get_achievements(clovek_id=greybox_id)
        except IndexError:
            return {"error": "Provided hash is not a valid hash."}
