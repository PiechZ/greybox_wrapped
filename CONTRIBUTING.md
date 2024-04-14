# Architecture of the achievement

- `achievement_name` both names and identifies the achievement for any frontend handlers
- `achievement_type` (either binary, numeric or percentile) identifies the handler for any generic achievement handler,
- `achievement_id` should uniquely identify the achievement granted to a person (and typically will be `achievement_name/person/year`) - might not be necessary if we keep person and year, and we should,
- `achievement_text` is the default text to display along with the achievement, which the frontend handler might override,
- `achievement_data` is a JSON dictionary of any data that is relevant to the achievement,
- `achievement_priority` is a tie-breaker in case of multiple awardings of the same kind of achievement and possibly a sorting mechanism. The higher the number, the higher the priority of the achievement, `1` being the lowest priority of the achievement.
- `achievement_description` is ???
