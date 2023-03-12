SELECT * FROM {{ ref('clovek_debata') }}
WHERE kidy > 90
AND nazev IN ('Debatní liga XXVIII.', 'Debate League XXVIII.')