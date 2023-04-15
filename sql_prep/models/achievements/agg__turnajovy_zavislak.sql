-- NOTE: Doesn't actually count up separate tournament_id's because they're not in the base model
-- -- only approximates the tournament count by counting up the number of tournament debates
with tournament_debates as (
    select
        clovek_id,
        school_year,
        count(*) as num_tournament_debates,
        ceil(count(*) / 5) as num_tournaments
    from
        {{ ref('base__debater_debata') }}
    where
        is_tournament
    group by
        clovek_id,
        school_year
),

achievement as (
    select
        tournament_debates.*,
        case
            when num_tournaments >= 1 and num_tournaments <= 2 then 'turnajový začátečník'
            when num_tournaments <= 4 then 'hotový turnajový harcovník'
            when num_tournaments <= 6 then 'kompletní turnajový štamgast'
            when num_tournaments > 6 then 'vyložený turnajový závislák'
        end as characteristic
    from
        tournament_debates
),

final as (
    select
        clovek_id,
        school_year,
        {{ make_achievement_id('turnajovy_zavislak') }},
        'Díky za účast na turnajích!' as achievement_name,
        'Po ' || num_tournaments || ' turnajích je z tebe ' || characteristic || '!' as achievement_description,
        4 as achievement_priority,
        json_object(
            'num_tournaments', num_tournaments,
            'num_tournament_debates', num_tournament_debates
        ) as achievement_data,
        'binary' as achievement_type
    from
        achievement
    where characteristic is not null
)

select * from final
