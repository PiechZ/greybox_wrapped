with aggregate_ib as (
    select * from {{ ref('int__debater_cumulative_ib') }}
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
        school_year,
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
