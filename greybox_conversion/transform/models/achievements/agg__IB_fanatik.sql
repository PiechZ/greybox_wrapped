with ib_base as (
    select * from {{ ref('base__debater_ib') }}
),

aggregate_ib as (
    select
        clovek_id,
        school_year,
        SUM(ibody) as celkem_ib
    from
        ib_base
    group by
        clovek_id,
        school_year
),

achievement as (
    select *
    from
        aggregate_ib
    where
        celkem_ib > 25
),

final as (
    select
        clovek_id,
        school_year,
        celkem_ib,
        {{ make_achievement_id('ib_fanatik') }},
        'IB fanatik' as achievement_name,
        'Za tuto sezónu máte na kontě více než 25 IB bodů! To by stačilo na odznáček, na který jiní střádají několik sezón.' as achievement_description,
        3 as achievement_priority,
        'binary' as achievement_type
    from
        achievement
)


select * from final
