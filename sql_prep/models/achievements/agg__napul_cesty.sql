WITH ib_base AS (
    SELECT * FROM {{ ref('base__debater_ib') }}
),

rocni_ib_tab AS(
    SELECT
        clovek_id,
        school_year,
        SUM(ibody) AS rocni_ib
    FROM
        ib_base
    GROUP BY
        clovek_id,
        school_year
),

aggregate_ib AS (
    SELECT
        clovek_id,
        school_year,
        rocni_ib,
        ROUND(SUM(rocni_ib) OVER (PARTITION BY clovek_id ORDER BY school_year ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW), 3) AS celkem_ib
    FROM
        rocni_ib_tab
    ORDER BY
        clovek_id,
        school_year
),

achievement AS(
    SELECT *
    FROM
        aggregate_ib
    WHERE
        celkem_ib BETWEEN 12.5 AND 24.999
),

final AS (
    SELECT
    clovek_id,
    celkem_ib,
    {{ make_achievement_id('napul_cesty') }},
    'Napůl cesty' as achievement_name,
    'Momentálně jsi za polovinou cesty k bronzovému odznáčku, konkrétně máš ' || celkem_ib || ' IB bodů!' as achievement_description,
    3 as achievement_priority,
    json_object('celkem_ib', celkem_ib) as achievement_data, 
    'numeric' as achievement_type
    FROM
        achievement
)


SELECT * FROM final