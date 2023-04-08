WITH base AS (
    SELECT * FROM {{ ref('base__debater_debata') }}
),

achievement as(
    SELECT
        clovek_id,
        school_year,
        COUNT() AS pocet_debat,
        pocet_debat*2 AS hours_debated,
    FROM base
    WHERE school_year IS NOT NULL
    GROUP BY clovek_id, school_year
),

final(
    SELECT
        clovek_id,
        school_year,
        'Sběratel debat' AS achievement_name,
    FROM 

)

SELECT * FROM final