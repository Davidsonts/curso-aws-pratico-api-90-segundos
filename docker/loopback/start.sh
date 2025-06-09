#!/usr/bin/env bash

set -e  # Encerra o script se algum comando falhar

echo 'Checking MySQL...'

# Loop para esperar MySQL estar disponível
until mysql -u"$MYSQL_USER" -p"$MYSQL_PASSWORD" -h "$MYSQL_HOST" -e ";" &> /dev/null; do
    echo 'Waiting for MySQL...'
    sleep 5
done

echo "MySQL is up!"

echo "Fixing MySQL user auth plugin to mysql_native_password..."
mysql -u"$MYSQL_USER" -p"$MYSQL_PASSWORD" -h "$MYSQL_HOST" -e "ALTER USER '$MYSQL_USER'@'%' IDENTIFIED WITH mysql_native_password BY '$MYSQL_PASSWORD'; FLUSH PRIVILEGES;"

DIR="/app/www/api/dist"
if [[ ! -e "$DIR" ]]; then
  echo "Dist folder missing, rebuilding API..."
  cd /app/www/api/ && npm run rebuild
fi

echo "Migrating DB..."
cd /app/www/api/dist/ && node migrate.js

echo 'Starting up API...'
if [ "$NODE_ENV" == "development" ]; then
  echo "Development MODE"
  pm2 start /app/docker/loopback/pm2/pm2-development.json
else
  echo "Production MODE"
  pm2 start /app/docker/loopback/pm2/pm2-production.json
fi

# Mantém o container ativo
tail -f /dev/null
