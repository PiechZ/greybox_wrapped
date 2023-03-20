with people as (
    select 
        clovek_id,
        klub_id
    from {{ source('raw', 'clovek') }}
),

-- Possible to get more information about clubs but we don't really need specifics

debates as (
    select * from {{ ref('base__debata') }}
),

debaters_in_debates as (
    select
        debata_id,
        clovek_id,
        role,
        kidy,
    from {{ source('raw', 'clovek_debata') }}
    where role in ('a1', 'a2', 'a3', 'n1', 'n2', 'n3')
),

final as (
    select
        *,
        debates.*,
        people.klub_id
    from debaters_in_debates
    left join debates using (debata_id)
    left join people using (clovek_id)
)

select * from final
