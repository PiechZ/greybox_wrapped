with ib_base as (
    select * from {{ ref('base__debater_ib') }}
),

rocni_ib_tab as (
    select
        clovek_id,
        school_year,
        SUM(ibody) as rocni_ib
    from
        ib_base
    group by
        clovek_id,
        school_year
),

aggregate_ib as (
    select
        clovek_id,
        school_year,
        rocni_ib,
        ROUND(SUM(rocni_ib) over (partition by clovek_id order by school_year rows between unbounded preceding and current row), 3) as celkem_ib
    from
        rocni_ib_tab
    order by
        clovek_id,
        school_year
),

achievement as (
    select *
    from
        aggregate_ib
    where
        celkem_ib between 12.5 and 24.999
),

final as (
    select
        clovek_id,
        celkem_ib,
        {{ make_achievement_id('napul_cesty') }},
        'Napůl cesty' as achievement_name,
        'Momentálně jsi za polovinou cesty k bronzovému odznáčku, konkrétně máš ' || celkem_ib || ' IB bodů!' as achievement_description,
        3 as achievement_priority,
        JSON_OBJECT('celkem_ib', celkem_ib) as achievement_data,
        'numeric' as achievement_type
    from
        achievement
)


select * from final
