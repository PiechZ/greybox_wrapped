with official_debates_per_person as (
    select * from {{ ref("base__debater_debata") }}
    where is_official_motion
),

achievement_base as (
    select
        clovek_id,
        school_year,
        count(*) as total_official_debates,
        sum(is_winner::decimal) as official_wins,
        sum(is_winner::decimal) / count(*) as win_rate
    from official_debates_per_person
    group by 1, 2
),

final as (
    select
        clovek_id,
        school_year,
        {{ make_achievement_id('pripravenost') }},
        'Štěstí přeje připraveným' as achievement_name,
        'Vyhrál/a jsi víc než 60% debat na oficiální připravenou tezi.' as achievement_description,
        json_object(
            'win_rate', win_rate, 
            'total_official_debates', total_official_debates
        ) as achievement_data,
        'binary' as achievement_type,
        3 as achievement_priority
    from achievement_base
    where win_rate > 0.6
)

select * from final
