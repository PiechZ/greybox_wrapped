WITH ib_base AS (
    SELECT * FROM {{ ref('base__debater_ib') }}
),

aggregate_ib AS (
    SELECT
        clovek_id,
        school_year,
        ROUND(SUM(ibody) OVER (PARTITION BY clovek_id ORDER BY school_year ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW), 3) AS celkem_ib
    FROM
        ib_base
),

achievement AS(
    SELECT *
    FROM
        aggregate_ib
    WHERE
        celkem_ib BETWEEN 12.5 AND 25
),

ranked_achievements AS (
    SELECT
        *,
        ROW_NUMBER() OVER (PARTITION BY clovek_id, school_year ORDER BY celkem_ib DESC) AS row_num
    FROM
        achievement
),

final AS (
    SELECT
    clovek_id,
    celkem_ib,
    {{ make_achievement_id('napul_cesty') }},
    'Napůl cesty' as achievement_name,
    'Momentálně jsi napůl cesty k bronzovému odznáčku, konkrétně máš ' || celkem_ib || ' IB bodů!' as achievement_description,
    3 as achievement_priority,
    json_object('celkem_ib', celkem_ib) as achievement_data, 
    'numeric' as achievement_type
    FROM
        ranked_achievements
    WHERE
        row_num = 1
)


SELECT * FROM final