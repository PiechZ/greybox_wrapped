with aggregate_ib as (
    select * from {{ ref('int__debater_ib_per_year') }}
),

achievement as (
    select *
    from
        aggregate_ib
    where
        rocni_ib > 25
),

final as (
    select
        clovek_id,
        school_year,
        {{ make_achievement_id('ib_fanatik') }},
        'IB fanatik' as achievement_name,
        'Za tuto sezónu máte na kontě více než 25 IB bodů! To by stačilo na odznáček, na který jiní střádají několik sezón.' as achievement_description,
        3 as achievement_priority,
        JSON_OBJECT('rocni_ib', rocni_ib) as achievement_data,
        'binary' as achievement_type
    from
        achievement
)


select * from final
