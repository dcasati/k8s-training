# Based on the work of lbosqmsft 
# https://hub.docker.com/r/lbosqmsft/mssql-python-pyodbc/

# mssql-python-pyodbc
# Python runtime with pyodbc to connect to SQL Server
FROM ubuntu:16.04

# apt-get and system utilities
RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y \
        apt-utils \
        apt-transport-https \
        build-essential \
        curl \
        debconf-utils \
        gcc \
        g++-5\
    && rm -rf /var/lib/apt/lists/*

# adding custom MS repository
RUN curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add - \
    && curl https://packages.microsoft.com/config/ubuntu/16.04/prod.list >\
         /etc/apt/sources.list.d/mssql-release.list

# install SQL Server drivers
RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive ACCEPT_EULA=Y \
        apt-get install -y msodbcsql unixodbc-dev

# install SQL Server tools
RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive ACCEPT_EULA=Y \
        apt-get install -y mssql-tools \
    && echo 'export PATH="$PATH:/opt/mssql-tools/bin"' >> ~/.bashrc \
    && /bin/bash -c "source ~/.bashrc"

# python libraries
RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y \
        python3-dev \
        python3-pip \
        python3-setuptools --no-install-recommends \
    && rm -rf /var/lib/apt/lists/*

# install necessary locales
RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y locales \
    && echo "en_US.UTF-8 UTF-8" > /etc/locale.gen \
    && locale-gen

# add sample code
COPY python-flask-server/ /app

RUN mkdir -p /app \
    && pip3 install --upgrade pip \
    && pip3 install --no-cache-dir -r /app/requirements.txt

WORKDIR /app
EXPOSE 8080

ENTRYPOINT ["python3"]

CMD ["-m", "swagger_server"]