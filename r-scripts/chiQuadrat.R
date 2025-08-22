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


cat("\n=== Chi-Quadrat-Test: SEX vs RESULTAT ===\n")
test <- chisq.test(tbl_geschlecht_ergebnis)
print(test)


dbDisconnect(con)
