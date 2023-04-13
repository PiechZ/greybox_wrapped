with base as (
    select * from {{ ref('base__rozhodci_debata') }}
),

achievement as (
    select
        clovek_id,
        school_year,
        count(*) as outvoted_debate_count,
    from base
    where
        judge_count > 1 
        and not is_draw
        and (
            (is_affirmative_win and not has_voted_affirmative)
            or (not is_affirmative_win and has_voted_affirmative)
        )
    group by 1, 2
),

final as (
    select
        clovek_id,
        school_year,
        'outvoted/' || clovek_id || '/' || school_year as achievement_id,
        'Přehlasován/a' as achievement_name,
        'Byl/a jsi jako rozhodčí přehlasován v ' || outvoted_debate_count || ' debatách.' as achievement_description,
        json_object(
            'outvoted_debate_count', outvoted_debate_count
        ) as achievement_data,
        'binary' as achievement_type,
        1 as achievement_priority
    from achievement
)

select * from final