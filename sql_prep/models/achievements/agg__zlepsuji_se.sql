WITH base AS (
    SELECT * FROM {{ ref('base__debater_debata') }}
),

newbies AS (
    SELECT * from base
    RIGHT JOIN {{ ref('base__newbies') }} using (clovek_id)
),

kidy_malych_kidu AS (
    SELECT
        clovek_id,
        school_year,
        debate_date,
    FROM newbies
    WHERE kidy > 75
    ORDER BY debate_date
),

achievement AS (
    SELECT DISTINCT ON (clovek_id) *
    FROM kidy_malych_kidu
),

final AS ( 
    SELECT    
        clovek_id,
        school_year,
        debate_date,
        'Zlepšuji se.' AS achievement_name,
        'Gratulujeme, zlepšuješ se! Letos se ti povedlo mít první řeč s více než 75 řečnickými body, a to ' || strftime(debate_date, '%d. %m. %Y') || '!' AS achievement_description,
        'achievement_zlepsuji_se/' || clovek_id || '/' || school_year AS achievement_id,
        'binary' AS achievement_type,
        2 AS achievement_priority
    FROM achievement
)

SELECT * FROM final