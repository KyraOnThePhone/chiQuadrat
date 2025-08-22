FROM rocker/tidyverse:latest

USER root

# ODBC Treiber für SQL Server installieren
RUN apt-get update && \
    apt-get install -y curl apt-transport-https gnupg unixodbc-dev && \
    curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add - && \
    curl https://packages.microsoft.com/config/debian/11/prod.list > /etc/apt/sources.list.d/mssql-release.list && \
    apt-get update && \
    ACCEPT_EULA=Y apt-get install -y msodbcsql18 && \
    rm -rf /var/lib/apt/lists/*

# R Pakete installieren (DBI + odbc für Verbindung zu MSSQL)
RUN R -e "install.packages(c('DBI','odbc'), repos='https://cloud.r-project.org')"

# Arbeitsverzeichnis
WORKDIR /home/rstudio/scripts

# Standard-Command: Container im Hintergrund offen halten
CMD ["tail", "-f", "/dev/null"]
