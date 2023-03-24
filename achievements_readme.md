# ADK Wrapped – Achievementy
Seznam achievementů, které se implementují, seznam není konečný a může dojít k úpravám

## Jednoduché na implementaci
### Pro zkušené debatéry
- „Ultimátní řečník“ - získá člověk, který v sezóně získal alespoň jednou více než 90 Kidů - `binary` - priorita 10
- „Neporazitelný“ – počet vyhraných debat v řadě - `numeric` - priorita 9
- „Dotknout se hvězd“ – počet debat, kde má člověk více než 85 Kidů - `numeric` - priorita 8

### Pro průměrné debatéry
- „Gastarbeiter“ – počet týmů, za které člověk debatoval - `numeric` - priorita 2
- „Lepší než průměr“ – počet debat, kdy má člověk více než 75 speaker pointů - `numeric` - priorita 3
- „Sběratel bodů“ – počet IB bodů jako debatér za sezónu - `numeric` - priorita 1
- „Dobrý řečník“ - průměrný počet Kidů za sezónu - `numeric` - priorita 1
- „Příprava je základ“ - získá člověk, který na oficiální teze má winrate více než 60% - `binary` - priorita 3

### Pro začínající debatéry
- „Moje první výhra“ - první vyhraná debata - `binary` - priorita 3
- „Jsem (poprvé) nejlepší!“ - první best speaker - `binary` - priorita 5
- „Zlepšuji se“ - první debata nad 75 kidů - `binary` - priorita 2
- „Talent“ - debatující první rok a zároveň s průměrem nad 75 kidů - `binary` - priorita 5

## Těžší na implementaci
- „Mistr pozice“ – řečnická pozice, na které má člověk nejvyšší průměr Kidů - `numeric`
- „Vítězná pozice“ – řečnická pozice, na které má člověk nejvíce výher/nejlepší winrate - `numeric`
- „Můj nejlepší turnaj“ – turnaj, na kterém má člověk nejlepší průměr Kidů - `numeric`
- „Důležité je skóre, ne body“ – počet low point winů - `numeric`
- „Pyrrhovo vítězství“ – počet prohraných debat jako best speaker - `numeric`

## Těžké na implementaci
- „Turnaj mistrů“ – turnaj, na kterém byl celkově nejlepší průměr Kidů 
- „Dream Team“ – tým, složený z lidí co na dané pozici mají nejlepší speaker pointy (každý člověk může být uveden jen jednou)
- „Gaussova křivka“ – ověření, že opravdu udělujeme body na základě Gaussovy křivky 
