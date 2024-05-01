WITH base AS (
    SELECT * FROM {{ ref('base__debater_debata') }}
),

newbies AS (
    SELECT * from base
    RIGHT JOIN {{ ref('base__newbies') }} using (clovek_id)
),

vyhry AS (
    SELECT
        clovek_id,
        school_year,
        debate_date,
    FROM newbies
    WHERE is_winner = true
    ORDER BY debate_date
),

/*achievement AS (
    SELECT
        clovek_id,
        school_year,
        MIN(debate_date)
    FROM vyhry
    GROUP BY clovek_id
),*/

achievement AS (
    SELECT DISTINCT ON (clovek_id) *
    FROM vyhry
),

final AS ( 
    SELECT    
        clovek_id,
        school_year,
        debate_date,
        'První výhra' AS achievement_name,
        'Letos se ti povedlo dosáhnout první výhry, a to ' || strftime(debate_date, '%d. %m. %Y') || '!' AS achievement_description,
        'achievement_prvni_vyhra/' || clovek_id || '/' || school_year AS achievement_id,
        'binary' AS achievement_type,
        3 as achievement_priority
    FROM achievement
)

SELECT * FROM final