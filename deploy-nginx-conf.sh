#!/bin/bash

# deploy-nginx-conf.sh

set -e

CONFIG_FILE="nginx-n8n.conf"
TARGET_DIR="/root/development/docker-nginx/conf.d/dockers/"
NGINX_CONTAINER_NAME="nginx"
COMPOSE_DIR="/root/development/docker-nginx"

echo "Развертывание конфигурации nginx..."

# Проверки
if [ ! -f "$CONFIG_FILE" ]; then
    echo "ОШИБКА: Файл $CONFIG_FILE не найден"
    exit 1
fi

if [ ! -d "$TARGET_DIR" ]; then
    echo "ОШИБКА: Директория $TARGET_DIR не найдена"
    exit 1
fi

if [ ! -d "$COMPOSE_DIR" ]; then
    echo "ОШИБКА: Директория docker compose $COMPOSE_DIR не найдена"
    exit 1
fi

# Копирование
echo "Копирование $CONFIG_FILE в $TARGET_DIR"
cp -v "$CONFIG_FILE" "$TARGET_DIR"

# Проверка и перезапуск/запуск контейнера
if [ $(docker ps -q -f name=$NGINX_CONTAINER_NAME) ]; then
    # Если контейнер запущен, перезапускаем nginx внутри контейнера
    echo "Контейнер $NGINX_CONTAINER_NAME запущен. Перезагрузка конфигурации nginx..."
    docker exec $NGINX_CONTAINER_NAME nginx -s reload
    echo "Конфигурация nginx успешно перезагружена"
else
    # Если контейнер не запущен, запускаем его через docker compose
    echo "Контейнер $NGINX_CONTAINER_NAME не запущен. Запуск с помощью docker compose..."
    cd "$COMPOSE_DIR"
    docker compose up -d $NGINX_CONTAINER_NAME
    echo "Контейнер nginx успешно запущен"
fi

echo "Развертывание успешно завершено!"
