WITH base AS (
    SELECT * FROM {{ ref('base__debater_debata') }}
),

prepare_hours AS(
    SELECT
        clovek_id,
        school_year,
        COUNT(*) * 2 AS hours_debated
    FROM base
    WHERE school_year IS NOT NULL
    GROUP BY clovek_id, school_year
),

achievement AS (
    SELECT *,
       CASE
        --WHEN hours_debated > 350 THEN 'naučit se nový jazyk na úroveň B1'
        --WHEN hours_debated > 200 THEN 'dohrát Total War: Empire - Definitive Edition'
        --WHEN hours_debated > 100 THEN 'dokončit průměrný online kurz na Udemy'
        -- THESE ARE IRRELEVANT SINCE NOONE HAS THAT MUCH DEBATES
        WHEN hours_debated >= 60 THEN 'zhlédnout všechny díly seriálu Breaking Bad'
        WHEN hours_debated >= 40 THEN 'zaletět na otočku do Japonska'
        WHEN hours_debated >= 32 THEN 'dohrát Cyberpunk 2077'
        WHEN hours_debated >= 24 THEN 'zhlédnout všechny díly seriálu Comeback'
        WHEN hours_debated >= 16 THEN 'projet všech 254 stanic metra v Dillí'
        WHEN hours_debated >= 8 THEN 'odpracovat jednu směnu'
        ELSE NULL
       END AS achievement_decider
    FROM prepare_hours

),

final AS (
    SELECT
        clovek_id,
        school_year,
        hours_debated,
        'Sběratel debat' AS achievement_name,
        'V této sezóně se ti podařilo debatovat přibližně ' || hours_debated || ' hodin. Za tu dobu se by se dalo například ' || achievement_decider || '. Zlepšovat se v debatování však dlouhodobně může být ještě užitečnější!' AS achievement_description,
        'achievement_sberatel_debat/' || clovek_id || '/' || school_year AS achievement_id,
        'numeric' AS achievement_type,
        1 AS achievement_priority
    FROM achievement
    WHERE achievement_decider IS NOT NULL
)

SELECT * FROM final
