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
    group by 1, 2
)

select * from rocni_ib_tab
