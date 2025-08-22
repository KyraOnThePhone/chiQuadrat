FROM mcr.microsoft.com/mssql/server:2022-latest

USER root

# Basis-Pakete installieren
RUN apt-get update && \
    apt-get install -y curl apt-transport-https gnupg software-properties-common && \
    curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add - && \
    curl https://packages.microsoft.com/config/ubuntu/$(lsb_release -rs)/prod.list > /etc/apt/sources.list.d/mssql-release.list && \
    apt-get update

# mssql-tools & unixodbc
RUN ACCEPT_EULA=Y apt-get install -y mssql-tools unixodbc-dev

# Machine Learning Services mit R installieren
RUN ACCEPT_EULA=Y apt-get install -y \
    mssql-server-extensibility \
    mssql-mlservices-packages-r

# Cleanup
RUN rm -rf /var/lib/apt/lists/*

# PATH erweitern
ENV PATH="$PATH:/opt/mssql-tools/bin"

# Startkommando
CMD ["/opt/mssql/bin/sqlservr"]
