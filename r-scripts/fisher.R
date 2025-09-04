library(DBI)
library(odbc)


con <- dbConnect(odbc(),
                 Driver   = "ODBC Driver 18 for SQL Server",
                 Server   = "sql",          
                 Database = "ChiQuadrat",      
                 UID      = "SA",
                 PWD      = "BratwurstIN23!",
                 Port     = 1433,
                 TrustServerCertificate = "yes")


df <- dbGetQuery(con, "
    SELECT BEHANDLUNG, RESULTAT, SEX
    FROM CHI_SQUARE
")


cat("\n=== SEX vs RESULTAT ===\n")
tbl_geschlecht_ergebnis <- table(df$SEX, df$RESULTAT)
print(tbl_geschlecht_ergebnis)

#2. Chi-Quadrat-Test
cat("\n=== Chi-Quadrat-Test: SEX vs RESULTAT ===\n")
chi2_test <- chisq.test(tbl_geschlecht_ergebnis)
print(chi2_test)

# Fisher's exakter Test
cat("\n=== Fisher's exakter Test: SEX vs RESULTAT ===\n")
fisher_test <- fisher.test(tbl_geschlecht_ergebnis)
print(fisher_test)

# Richtung des Effekts (Odds Ratio)
cat("\nOdds Ratio (exakter Schätzwert):\n")
print(fisher_test$estimate)

cat("\nKonfidenzintervall für Odds Ratio:\n")
print(fisher_test$conf.int)


dbDisconnect(con)