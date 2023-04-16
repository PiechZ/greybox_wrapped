{% set victory_window = 10 %}

with base as (
    select * from {{ ref('base__debater_debata') }}
    -- Ignore draws, since they typically mean show-debates or other unusual cases
    where not is_draw
),

victory_window as (
    -- Count up the number of victories in the past N debates
    select
        clovek_id,
        school_year,
        sum(case when is_winner then 1 else 0 end) over (
            partition by clovek_id, school_year
            order by debate_date
            rows between {{ victory_window - 1 }} preceding and current row
        ) as victories,
    from base
),

victories_through_window as (
    -- Keep only people whose victory streaks were at least N long
    select distinct
        clovek_id,
        school_year
    from victory_window
    where victories >= {{ victory_window }}
),

final as (
    select
        clovek_id,
        school_year,
        {{ make_achievement_id('neporazitelny') }},
        'Neporazitelný' as achievement_name,
        'Vyhrál/a jsi v alespoň {{ victory_window }} debatách za sebou!' as achievement_description,
        json_object('victory_window', {{ victory_window }}) as achievement_data,
        'binary' as achievement_type,
        9 as achievement_priority
    from victories_through_window
)

select * from final
