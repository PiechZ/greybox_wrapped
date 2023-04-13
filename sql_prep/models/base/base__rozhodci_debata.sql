with debates as (
    select * from {{ ref('base__debata') }}
),

judges as (
    select
        clovek_id,
        debata_id,
        rozhodnuti as has_voted_affirmative,
        row_number() over (partition by debata_id) as judge_rank,
        row_number() over (
            partition by debata_id order by clovek_id asc
        ) as judge_seniority
    from {{ source('raw', 'clovek_debata') }}
    where role = 'r'
),

final as (
    select
        debates.*,
        judges.clovek_id,
        judges.has_voted_affirmative,
        judges.judge_rank,
        judges.judge_seniority
    from judges
    left join debates using (debata_id)
)

select * from final
