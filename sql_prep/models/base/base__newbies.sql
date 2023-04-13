with base as (
    select * from {{ ref('base__debater_debata') }}
),

debate_min_max_year as (
    select
        clovek_id,
        min(school_year) as min_year,
        max(school_year) as max_year
    from base
    group by 1
),

min_year_current as (
    select clovek_id
    from debate_min_max_year
    where min_year = {{ var('current_school_year') }}
-- and min_year = max_year
),

judges as (
    select clovek_id from {{ ref('base__rozhodci_debata') }}
),

final as (
    select clovek_id from min_year_current
    where
        clovek_id not in (select clovek_id from judges)
)

select * from final
