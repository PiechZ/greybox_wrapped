with rocni_ib_tab as (
    select * from {{ ref('int__debater_ib_per_year') }}
),

aggregate_ib as (
    select
        clovek_id,
        school_year,
        ROUND(SUM(rocni_ib) over (partition by clovek_id order by school_year rows between unbounded preceding and current row), 3) as celkem_ib
    from
        rocni_ib_tab
)

select * from aggregate_ib
