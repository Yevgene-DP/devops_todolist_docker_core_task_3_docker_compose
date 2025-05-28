#!/bin/sh
set -xe

echo "Waiting for MySQL server socket to be available…"
until nc -z db 3306; do
  echo "  ↳ port 3306 not yet open…"
  sleep 1
done

echo "Waiting for MySQL to finish initializing users…"
sleep 10

echo "Pinging as root…"
mysqladmin ping -h db -u root -proot --silent

echo "Pinging as app_user…"
mysqladmin ping -h db -u app_user -p1234 --silent

echo "MySQL ready — running migrations"
python manage.py migrate --noinput

echo "Starting Django server"
exec python manage.py runserver 0.0.0.0:8080
