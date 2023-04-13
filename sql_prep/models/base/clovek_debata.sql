select
    debata.debata_id,
    role,
    kidy,
    clovek.clovek_id,
    liga.liga_id,
    liga.rocnik,
    liga.nazev,
    debata.teze_id,
    teze.jazyk
from {{ source('raw', 'clovek_debata') }}
left join {{ source('raw', 'clovek') }} using (clovek_id)
left join {{ source('raw', 'debata') }} using (debata_id)
left join {{ source('raw', 'turnaj') }} using (turnaj_id)
left join {{ source('raw', 'liga') }} using (liga_id)
left join {{ source('raw', 'teze') }} on debata.teze_id = teze.teze_id
where role in ('a1', 'a2', 'a3', 'n1', 'n2', 'n3')
