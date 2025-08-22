# chiQuadrat
Chi-Quadrat Test als Schulprojekt bei Herrn Trimkowski
Larissa & Kyra
statistik, datenanalyse, mathe (grundrechenarten)

R ausführen im Docker Container: 
Rscript /home/rstudio/scripts/hello.R


Ein Teil des Programms soll rein auf dem SQL Server geschehen. (durch Einstellungen, Funktionen, etc)

Dokumentation in ARIS (oder ähnlichem: draw.io, auf einem Flipchart etc.)

Chi-Quadrat-Test
ein statistisches Verfahren, das vor allem dazu dient, zu überprüfen, ob es einen signifikanten Zusammenhang zwischen zwei 
kategorialen Variablen gibt – also Variablen, die in Kategorien eingeteilt sind (z. B. Geschlecht: männlich/weiblich, Schulabschluss:ja nein).

Fragestellung: Besteht ein Zusammenhang zwischen zwei kategorialen Variablen? 

Beispiel:
Gibt es einen Zusammenhang zwischen dem Geschlecht einer Person (männlich/weiblich) und dem Schulabschluss (ja/nein)? 

    Du erhebst Daten von 200 Personen und trägst sie in eine Kreuztabelle (Kontingenztafel) ein.
    Der Chi-Quadrat-Test vergleicht dann die beobachteten Häufigkeiten in den Zellen der Tabelle mit den erwarteten Häufigkeiten, die du hättest, wenn kein Zusammenhang bestehen würde (also wenn die Variablen unabhängig wären).
    Ist der Unterschied zwischen beobachteten und erwarteten Werten groß genug, deutet das auf einen signifikanten Zusammenhang hin.


Wichtige Voraussetzungen 

    Die Daten müssen kategorial (nominal oder ordinal) sein.
    Die Beobachtungen müssen unabhängig sein (z. B. eine Person wird nur einmal erfasst).
    Die erwarteten Häufigkeiten pro Zelle sollten nicht zu klein sein (Faustregel: meist mindestens 5 pro Zelle, sonst evtl. Fisher’s exakter Test verwenden).

Interpretation des Ergebnisses 

    Der Test liefert einen p-Wert.
    Ist der p-Wert kleiner als das Signifikanzniveau (meist 0,05), dann verwirfst du die Nullhypothese.
        Bei Unabhängigkeitstest: Es gibt einen signifikanten Zusammenhang zwischen den Variablen.
        Bei Anpassungstest: Die beobachtete Verteilung weicht signifikant von der erwarteten ab.

 Prüfgröße chi-quadrat				Wahrscheinlichkeit des Zufallsergebnis
 
 2,71								10%
 3,84								5%
 6,64								1%
 10,83								0,1%

 chi-quadrat > 3,84 -> signifikant (irrtumswahrscheinlichkeit 5%)

1. Nullhypothese muss gestellt werden.
z.b. Es gibt keinen zusammenhand zwischen A und B. 
Man guckt dann, ob diese Hypothese stimmt

Mindestens 6 Ergebnisse pro Feld für den Test