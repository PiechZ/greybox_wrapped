SELECT nazev, clovek_id, COUNT() FROM {{ ref('clovek_debata') }}
WHERE nazev IN ('Debatní liga XXVIII.', 'Debate League XXVIII.')
AND kidy > 75
GROUP BY nazev, clovek_id

/*Prvni pokus:
SELECT * FROM {{ ref('clovek_debata') }} WHERE clovek_ID = 2956
AND kidy > 75
AND nazev IN ('Debatní liga XXVIII.', 'Debate League XXVIII.')

Zobrazi debaty nad 75 kidu jenom z poslednich lig a to u jednoho nejmenovaneho debatera :-)

Druhy pokus:
SELECT nazev,COUNT() FROM {{ ref('clovek_debata') }} WHERE clovek_ID = 2956 
AND kidy > 75
AND nazev IN ('Debatní liga XXVIII.', 'Debate League XXVIII.')
GROUP BY nazev

Prepsane pouze to prvni jinak a pro jednoho konkretniho cloveka*/
