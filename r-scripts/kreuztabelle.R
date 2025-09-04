
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




cat("\n=== BEHANDLUNG vs RESULTAT ===\n")
tbl_behandlung_ergebnis <- table(df$BEHANDLUNG, df$RESULTAT)
print(tbl_behandlung_ergebnis)

cat("\n=== SEX vs RESULTAT ===\n")
tbl_geschlecht_ergebnis <- table(df$SEX, df$RESULTAT)
print(tbl_geschlecht_ergebnis)

cat("\n=== BEHANDLUNG vs SEX ===\n") #quatsch
tbl_behandlung_geschlecht <- table(df$BEHANDLUNG, df$SEX)
print(tbl_behandlung_geschlecht)


dbDisconnect(con)

