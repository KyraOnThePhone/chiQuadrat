library(shiny)
library(ggplot2)
library(DBI)
library(odbc)

# Funktion: Verbindung zur SQL-Datenbank herstellen 
connect_to_sql <- function() {
  con <- tryCatch({
    dbConnect(odbc::odbc(),
              Driver = "ODBC Driver 17 for SQL Server",
              Server = "database",  
              Database = "ChiQuadrat",
              UID = "SA",
              PWD = "BratwurstIN23!",
              Port = 1433,
              TrustServerCertificate = "yes")
  }, error = function(e) {
    return(NULL)
  })
  return(con)
}

# UI
ui <- fluidPage(
  titlePanel("Intelligente Test-App: Welcher Test passt?"),
  sidebarLayout(
    sidebarPanel(
      h4("Wähle die Variablen aus"),
      selectInput("var1", "Erste Variable:", choices = ""),
      selectInput("var2", "Zweite Variable:", choices = ""),
      actionButton("run", "Test starten", class = "btn-primary"),
      br(), br(),
      verbatimTextOutput("connection_status")
    ),
    mainPanel(
      h4("Entscheidung & Ergebnis"),
      verbatimTextOutput("decision"),
      verbatimTextOutput("result"),
      plotOutput("plot")
    )
  )
)

#Server
server <- function(input, output, session) {
  
  # Verbindung herstellen und Daten laden
  con <- connect_to_sql()
  if (!is.null(con)) {
    output$connection_status <- renderText("Verbindung zur SQL-Datenbank hergestellt.")
    df <- dbGetQuery(con, "SELECT BEHANDLUNG, RESULTAT, SEX FROM CHI_SQUARE")
    dbDisconnect(con)
  } else {
    output$connection_status <- renderText("Keine Verbindung - verwende Beispiel-Daten.")
    # Fallback-Daten mit allen drei Spalten
    df <- data.frame(
      BEHANDLUNG = sample(c("A", "B"), 100, replace = TRUE),
      RESULTAT = sample(c("Geheilt", "Gestorben"), 100, replace = TRUE),
      SEX = sample(c("M", "W"), 100, replace = TRUE)
    )
  }
  
  # Variablen-Auswahl mit allen Spalten füllen
  observe({
    updateSelectInput(session, "var1", choices = names(df), selected = names(df)[1])
    updateSelectInput(session, "var2", choices = names(df), selected = names(df)[2])
  })
  
  # Test starten
  observeEvent(input$run, {
    req(input$var1, input$var2)
    
    # Sicherstellen, dass nicht dieselbe Variable gewählt wurde
    if (input$var1 == input$var2) {
      output$decision <- renderText("Bitte zwei verschiedene Variablen wählen!")
      return()
    }
    
    # Kreuztabelle erstellen
    tbl <- table(df[[input$var1]], df[[input$var2]])
    
    # Nur Tabellen mit mindestens 2x2 erlauben
    if (nrow(tbl) < 2 || ncol(tbl) < 2) {
      output$decision <- renderText("Eine der Variablen hat nur eine Kategorie.")
      return()
    }
    
    # Chi²-Test für erwartete Häufigkeiten
    chi2_test <- chisq.test(tbl)
    min_erwartet <- min(chi2_test$expected)
    
    # Entscheidungslogik
    if (min_erwartet < 5) {
      test_result <- fisher.test(tbl)
      p <- test_result$p.value
      or <- if (!is.null(test_result$estimate)) round(test_result$estimate, 2) else NA
      ki <- if (!is.null(test_result$conf.int)) round(test_result$conf.int, 2) else c(NA, NA)
      
      entscheidung <- paste0(
        "Erwartete Häufigkeit < 5 (min. ", round(min_erwartet, 2), 
        ").\nFisher's exakter Test (exakt).\n",
        "p = ", round(p, 4), 
        " → ", ifelse(p < 0.05, "SIGNIFIKANT", "NICHT SIGNIFIKANT")
      )
      
      if (!is.na(or)) {
        zusatz <- paste0("\n\nOdds Ratio = ", or,
                         " (95% KI: ", ki[1], "-", ki[2], ")")
        entscheidung <- paste0(entscheidung, zusatz)
      }
      
    } else if (nrow(tbl) == 2 && ncol(tbl) == 2) {
      test_result <- chisq.test(tbl, correct = TRUE)  # Yates-Korrektur
      p <- test_result$p.value
      entscheidung <- paste0(
        "2x2-Tabelle, alle erwarteten ≥ 5.\nChi² mit Yates-Korrektur.\n",
        "p = ", round(p, 4), 
        " → ", ifelse(p < 0.05, "SIGNIFIKANT", "NICHT SIGNIFIKANT")
      )
    } else {
      test_result <- chisq.test(tbl, correct = FALSE)
      p <- test_result$p.value
      entscheidung <- paste0(
        "Allgemeine Tabelle, alle erwarteten ≥ 5.\nKlassisches Chi².\n",
        "p = ", round(p, 4), 
        " → ", ifelse(p < 0.05, "SIGNIFIKANT", "NICHT SIGNIFIKANT")
      )
    }
    
    output$decision <- renderText(entscheidung)
    
    # interpretation
    interpretation <- ifelse(p < 0.05,
      "Es gibt einen statistisch signifikanten Zusammenhang zwischen den Variablen.",
      "Es gibt keinen statistisch signifikanten Zusammenhang zwischen den Variablen."
    )
    output$result <- renderText(paste("\nInterpretation:\n", interpretation))
    
    # Diagramm
    output$plot <- renderPlot({
      ggplot(df, aes_string(input$var1, fill = input$var2)) +
        geom_bar(position = "dodge") +
        labs(title = paste("Häufigkeiten:", input$var1, "vs", input$var2)) +
        theme_minimal() +
        theme(axis.text.x = element_text(angle = 45, hjust = 1))
    })
  })
}

# App starten
shinyApp(ui = ui, server = server)