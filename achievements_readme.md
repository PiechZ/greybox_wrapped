# greybox Wrapped – Achievementy
Seznam achievementů, které se implementují, seznam není konečný a může dojít k úpravám.
Pravidla pro udělování achievementů:
- Člověk by měl získat 3 a více achievementů
- Člověk získává nejdříve achievementy s vyšší prioritou
- Člověk momentálně získává všechny achievementy, u kterých splní kritéria. Do budoucna se počítá pouze se získáním 10 achievementů dle nejvyšší priority.

## Implementované achievementy
### Pro zkušené debatéry
- „Nejlepší mluvčí roku v roli“ - člověk, který v daném roce měl na dané řečnické pozici nejvyšší průměr řečnických bodů - `binary` - priorita 10
- „Dotknout se hvězd“ – počet debat, kde má člověk více než 85 řečnických bodů - `numeric` - priorita 8
- „Neporazitelný“ – v případě deseti a více vyhraných debat v řadě - `numeric` - priorita 9
- „Ultimátní řečník“ - získal/a alespoň jednou více než 90 řečnických bodů - `binary` - priorita 10

### Pro průměrné debatéry
- „Dobrý řečník“ - průměrný počet řečnických bodů za sezónu - `numeric` - priorita 1
- „Oblíbená role“ - nejoblíbenější řečnická pozice - `binary` - priorita 6
- „Gastarbeiter“ – debatování za více týmů na lize - `binary` - priorita 4
- „Lepší než průměr“ – počet debat, kdy má člověk více než 75 speaker pointů - `numeric` - priorita 3
- „Co je doma, to se počítá“ – výhra v debatě, kde tým získá méně řečnických bodů než soupeř, který prohrál - `binary` - priorita 5
- „Lingvista“ - pro toho, kdo debatoval ve více jazycích - `binary` - priorita 2 + n pro n počet jazyků,
- „Štěstí přeje připraveným“ - získá člověk, který na oficiální teze má poměr vítezství více než 60% - `binary` - priorita 3
- „Sběratel debat“ – počet debat jako debatér za sezónu - `numeric` - priorita 1
- „Turnajový závislák“ - množství turnajů, kterých se zůčastnil/a - `binary` - priorita 2

### Pro začínající debatéry
- „Poprvé nejlepší!“ - první nejlepší řečník v prvním roce debatování - `binary` - priorita 7
- „Moje první výhra“ - první vyhraná debata - `binary` - priorita 3
- „Talent“ - debatující první rok a zároveň s průměrem nad 75 řečnických bodů - `binary` - priorita 5
- „Zlepšuji se“ - první debata nad 75 řečnických bodů - `binary` - priorita 2

### Pro rozhodčí
- „První rozhodnutá debata“ - debata, ve které rozhodčí poprvé rozhodoval/a - `binary` - priorita 5
- „Rozhodnuté debaty“ - počet debat, které rozhodčí rozhodl/a, včetné úsilí, které to zabralo - `numeric` - priorita 2
- „Přehlasován/a“ - počet debat, ve kterých je rozhodčí přehlasován/a - `numeric` - priorita 3
- „Vážená pomoc“ - počet turnajů, kterých se jako rozhodčí zůčastnil/a - `binary` - priorita 1
