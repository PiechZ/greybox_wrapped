with all_achievements as (
    select *
    from {{ ref('final__all_achievements') }}
),

final as (
    select * from all_achievements
    where school_year = {{ var('current_school_year') }}
    or school_year is NULL
)

select * from final
