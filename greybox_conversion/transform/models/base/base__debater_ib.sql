with debate_activity as (
    select
        clovek_id,
        rocnik as school_year,
        -- debata_id,
        ibody,
        -- role,
        'debate' as activity_type
    from {{ source('raw', 'clovek_debata_ibody') }}
),

special_activity as (
    select
        clovek_id,
        rocnik as school_year,
        -- clovek_ibody_id,
        ibody,
        'other' as activity_type
    from {{ source('raw', 'clovek_ibody') }}
),

final as (
    select * from debate_activity
    union all
    select * from special_activity
)

select * from final
