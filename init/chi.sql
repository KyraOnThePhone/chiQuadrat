-- Variabeln deklarieren

DECLARE @mGeheiltA FLOAT;
DECLARE @mGestorbenB FLOAT;
DECLARE @wGeheiltC FLOAT;
DECLARE @wGestorbenD FLOAT;
DECLARE @SumAC FLOAT;
DECLARE @SumBD FLOAT;
DECLARE @N FLOAT;
DECLARE @Chi2 FLOAT;
DECLARE @pValue FLOAT;

-- Werte aus Tabelle laden & als Variablen speichern)
SET @mGeheiltA   = (SELECT COUNT(*) FROM CHI_SQUARE WHERE SEX = 'M' AND RESULTAT = 'Geheilt');
SET @mGestorbenB = (SELECT COUNT(*) FROM CHI_SQUARE WHERE SEX = 'M' AND RESULTAT = 'Gestorben');
SET @wGeheiltC   = (SELECT COUNT(*) FROM CHI_SQUARE WHERE SEX = 'W' AND RESULTAT = 'Geheilt');
SET @wGestorbenD = (SELECT COUNT(*) FROM CHI_SQUARE WHERE SEX = 'W' AND RESULTAT = 'Gestorben');

-- Berechnungen
SET @SumAC = @mGeheiltA + @wGeheiltC;
SET @SumBD = @mGestorbenB + @wGestorbenD;
SET @N     = @SumAC + @SumBD;

SET @Chi2 = @N * POWER((@mGeheiltA * @wGestorbenD - @mGestorbenB * @wGeheiltC), 2) 
            / (@SumAC * @SumBD * (@mGeheiltA + @mGestorbenB) * (@wGeheiltC + @wGestorbenD));

-- p-Wert aus R 
SET @pValue = 0.9797;

-- Ausgabe
PRINT 'Chi-Quadrat Wert: ' + CAST(@Chi2 AS VARCHAR(20));
PRINT 'p-Wert: ' + CAST(@pValue AS VARCHAR(20));
SELECT 
    @Chi2 AS Chi2_Wert,
    @pValue AS p_Wert,
    CASE 
        WHEN @pValue < 0.05 THEN 'Signifikanter Zusammenhang.'
        ELSE 'Kein signifikanter Zusammenhang.'
    END AS Ergebnis;