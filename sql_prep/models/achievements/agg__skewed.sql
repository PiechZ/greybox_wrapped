{% set skew_size = 0.2 %}

with base as (
    select * from {{ ref('base__rozhodci_debata') }}
),

all_decision_counts as (
    select
        clovek_id,
        school_year,
        count(*) as decision_count
    from base
    group by 1, 2
),

count_by_decision as (
    select
        clovek_id,
        school_year,
        {{ dbt_utils.pivot(
            column='has_voted_affirmative',
            values=[true, false],
            agg='sum'
        ) }}
    from base
    group by 1, 2
),

decision_ratio as (
    select
        clovek_id,
        school_year,
        "True" as affirmative_votes,
        "False" as negative_votes,
        "True" / ("True" + "False")::float as decision_ratio
    from count_by_decision
),

decision_ratio_skew as (
    select
        clovek_id,
        school_year,
        decision_ratio,
        decision_ratio < {{ skew_size }} or decision_ratio > 1 - {{ skew_size }} as is_skewed,
        case
            when decision_ratio < {{ skew_size }} then 'negativní'
            when decision_ratio > 1 - {{ skew_size }} then 'afirmativní'
            else null
        end as skew_direction,
        all_decision_counts.decision_count
    from decision_ratio
    left join all_decision_counts using (clovek_id, school_year)
),

final as (
    select
        clovek_id,
        school_year,
        'skewed/' || clovek_id || '/' || school_year as achievement_id,
        'Nadržování?' as achievement_name,
        'Volil jsi stranu ' || 'afirmativní' || ' v ' || round(decision_ratio * 100) || '% případů.' as achievement_description,
        json_object(
            'decision_ratio', decision_ratio,
            'skew_direction', skew_direction,
            'decision_count', decision_count
        ) as achievement_data,
        'binary' as achievement_type,
        2 as achievement_priority,
    from decision_ratio_skew
    where is_skewed and decision_count >= 10
)

select * from final