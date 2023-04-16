WITH first_year_debaters AS (
  SELECT
    clovek_id,
    MIN(school_year) AS first_school_year
  FROM
    {{ ref("base__debater_debata") }}
  GROUP BY
    clovek_id
),
first_ranked_debates AS (
  SELECT
    clovek_id,
    school_year,
    debata_id,
    debate_date,
    RANK() OVER (PARTITION BY debata_id ORDER BY kidy DESC) AS speaker_rank
  FROM
    {{ ref("base__debater_debata") }}
),
first_year_first_ranked_debates AS (
  SELECT
    first_year_debaters.clovek_id,
    first_ranked_debates.school_year,
    first_ranked_debates.debata_id,
    first_ranked_debates.debate_date,
    first_ranked_debates.speaker_rank
  FROM
    first_year_debaters
  JOIN
    first_ranked_debates ON first_year_debaters.clovek_id = first_ranked_debates.clovek_id AND first_year_debaters.first_school_year = first_ranked_debates.school_year
  WHERE
    first_ranked_debates.speaker_rank = 1
),
first_congratulations AS (
  SELECT
    clovek_id,
    school_year,
    MIN(debate_date) AS first_congratulation_date
  FROM
    first_year_first_ranked_debates
  GROUP BY
    clovek_id,
    school_year
),
final AS (
  SELECT
    first_congratulations.clovek_id,
    first_congratulations.school_year,
    {{ make_achievement_id("poprve_nejlepsi") }},
    'Poprvé nejlepší!' as achievement_name,
    'Dne ' || strftime(first_congratulations.first_congratulation_date, '%d. %m. %Y') || 
        ' jsi byl/a poprvé nejlepším mluvčím debaty ve svém prvním roce debatování!' AS achievement_description,
    7 as achievement_priority,
    'binary' as achievement_type,
    json_object('date', first_congratulations.first_congratulation_date) as achievement_data
  FROM
    first_congratulations
)

SELECT * FROM final
