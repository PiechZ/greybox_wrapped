from pydantic import BaseModel
from pydantic.types import PositiveInt
from typing import Any, Literal, Mapping


class Achievement(BaseModel):
    clovek_id: PositiveInt
    school_year: PositiveInt

    achievement_id: str
    achievement_name: str
    achievement_type: Literal["binary", "numeric", "percentile"]
    achievement_priority: PositiveInt
    achievement_description: str
    achievement_data: Mapping[str, Any]

    @property
    def achievement_text(self):
        return self.achievement_text.format(**self.achievement_data)