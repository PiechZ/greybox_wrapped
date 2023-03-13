SELECT
    debata.debata_id,
    role,
    kidy,
    clovek.clovek_id,
    liga.liga_id,
    liga.nazev,
    debata.teze_id,
    teze.jazyk
FROM {{ source('raw', 'clovek_debata') }}
LEFT JOIN {{ source('raw', 'clovek') }} USING (clovek_id)
LEFT JOIN {{ source('raw', 'debata') }} USING (debata_id)
LEFT JOIN {{ source('raw', 'turnaj') }} USING (turnaj_id)
LEFT JOIN {{ source('raw', 'liga') }} USING (liga_id)
LEFT JOIN {{ source('raw', 'teze') }} ON debata.teze_id = teze.teze_id
WHERE role IN ('a1', 'a2', 'a3', 'n1', 'n2', 'n3')
