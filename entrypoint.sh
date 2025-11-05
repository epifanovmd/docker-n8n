#!/bin/bash
# entrypoint.sh

set -e

echo "Setting up n8n directories and permissions..."

# Создаем директории если их нет
mkdir -p n8n/data n8n/config

# Настраиваем права
chown -R 1000:1000 n8n/
chmod -R 755 n8n/

echo "Permissions set. Starting n8n..."

# Запускаем основной процесс
exec n8n start
