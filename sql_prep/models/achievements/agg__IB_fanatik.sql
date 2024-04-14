WITH ib_base AS (
    SELECT * FROM {{ ref('base__debater_ib') }}
),

aggregate_ib AS (
    SELECT
        clovek_id,
        school_year,
        SUM(ibody) AS celkem_ib
    FROM
        ib_base
    GROUP BY
        clovek_id,
        school_year
),

achievement AS(
    SELECT *
    FROM
        aggregate_ib
    WHERE
        celkem_ib > 25
),

final AS (
    SELECT
    clovek_id,
    school_year,
    celkem_ib,
    {{ make_achievement_id('IB_fanatik') }},
    'IB fanatik' as achievement_name,
    'Za tuto sezónu máte na kontě více než 25 IB bodů! To by stačilo na odznáček, na který jiní střádají několik sezón.' as achievement_description,
    3 as achievement_priority,
    'binary' as achievement_type
    FROM
        achievement
)


SELECT * FROM final