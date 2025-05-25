with people as (
    select
        clovek_id,
        klub_id
    from {{ source('raw', 'clovek') }}
),

-- Possible to get more information about clubs but we don't really need specifics

debates as (
    select * from {{ ref('base__debata') }}
    where debata_id != 0
    and school_year is not null
),

debaters_in_debates as (
    select
        debata_id,
        clovek_id,
        role,
        kidy,
        role in ('a1', 'a2', 'a3') as is_affirmative_speaker
    from {{ source('raw', 'clovek_debata') }}
    where role in ('a1', 'a2', 'a3', 'n1', 'n2', 'n3')
),

final as (
    select
        debaters_in_debates.*,
        {{ dbt_utils.star(from=ref('base__debata'), except=['debata_id'], relation_alias='debates') }},
        people.klub_id,
        not debates.is_draw and (
            (debaters_in_debates.is_affirmative_speaker and debates.is_affirmative_win)
            or (not debaters_in_debates.is_affirmative_speaker and not debates.is_affirmative_win)
        ) as is_winner
    from debaters_in_debates
    left join debates using (debata_id)
    left join people using (clovek_id)
    where debates.debata_id is not null  -- drop debates without corresponding records in base__debata
)

select * from final
