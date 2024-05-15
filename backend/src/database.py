import duckdb
from src.achievement import Achievement
from typing import List, Union
import pathlib
import json

class Database:
    path: pathlib.Path

    def __init__(self, path: Union[str, pathlib.Path]):
        self.connection = duckdb.connect(database=str(path), read_only=True)


    # FIXME: Should this instead be a static method of Achievement?
    def get_achievements(self, clovek_id: int) -> List[Achievement]:
        # This is not SQL injection because Pydantic/FastAPI guarantees
        # clovek_id passed in URI is int
        achievements = self.connection.sql(
            "SELECT * FROM adk_wrapped.main.final__current_achievements "
            f"WHERE clovek_id = {clovek_id} "
            "ORDER BY achievement_priority DESC"
        ).df()
        achievements['achievement_data'] = achievements['achievement_data'].apply(json.loads)
        return [Achievement(**achievement) for _, achievement in achievements.iterrows()]
        # return achievements
