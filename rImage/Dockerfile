FROM rocker/tidyverse:latest

USER root

# ODBC Treiber für SQL Server installieren
RUN apt-get update && \
    apt-get install -y curl apt-transport-https gnupg unixodbc-dev wget && \
    curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add - && \
    curl https://packages.microsoft.com/config/debian/11/prod.list > /etc/apt/sources.list.d/mssql-release.list && \
    apt-get update && \
    ACCEPT_EULA=Y apt-get install -y msodbcsql18 && \
    rm -rf /var/lib/apt/lists/*

# R-Pakete installieren: DBI, odbc, shiny, ggplot2
RUN R -e "install.packages(c('DBI', 'odbc', 'shiny', 'ggplot2'), repos='https://cloud.r-project.org')"

# Arbeitsverzeichnis für Skripte
WORKDIR /home/rstudio/scripts

# Shiny-App-Port freigeben
EXPOSE 3838

# App starten (wenn app.R existiert)
CMD ["R", "-e", "shiny::runApp('/home/rstudio/scripts/app.R', host='0.0.0.0', port=3838)"]