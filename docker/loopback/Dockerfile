FROM node:14

EXPOSE 3001

USER root
WORKDIR /app

ENV DEBIAN_FRONTEND=noninteractive

# Instala wget, gnupg e adiciona o repositório MySQL 8.x
RUN apt-get update && \
    apt-get install -y wget gnupg lsb-release && \
    wget https://dev.mysql.com/get/mysql-apt-config_0.8.30-1_all.deb && \
    echo "mysql-apt-config mysql-apt-config/select-server select mysql-8.0" | \
      DEBIAN_FRONTEND=noninteractive debconf-set-selections && \
    dpkg -i mysql-apt-config_0.8.30-1_all.deb && \
    rm mysql-apt-config_0.8.30-1_all.deb && \
    apt-get update && \
    apt-get install -y mysql-client && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# npm 8 é a última versão compatível com Node 14
RUN npm install -g npm@8 pm2 && \
    pm2 install pm2-logrotate
