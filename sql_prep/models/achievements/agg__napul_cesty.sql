WITH ib_base AS (
    SELECT * FROM {{ ref('base__debater_ib') }}
),

aggregate_ib AS (
    SELECT
        clovek_id,
        ANY_VALUE(school_year) as school_year,
        SUM(ibody) AS celkem_ib
    FROM
        ib_base
    GROUP BY
        clovek_id,
),

achievement AS(
    SELECT *
    FROM
        aggregate_ib
    WHERE
        celkem_ib BETWEEN 12.5 AND 25
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
        achievement
)


SELECT * FROM final