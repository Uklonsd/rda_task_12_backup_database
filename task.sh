#! /bin/bash

if [[ -z "$DB_USER" || -z "$DB_PASSWORD" ]]; then
  echo "Помилка: DB_USER або DB_PASSWORD не встановлено."
  exit 1
fi

SOURCE_DB="ShopDB"
FULL_BACKUP_DB="ShopDBReserve"
DATA_BACKUP_DB="ShopDBDevelopment"

FULL_BACKUP_FILE="full_backup.sql"
echo "Створення повного резервного копіювання $SOURCE_DB..."
mysqldump -u "$DB_USER" -p"$DB_PASSWORD" "$SOURCE_DB" > "$FULL_BACKUP_FILE"

if [[ $? -ne 0 ]]; then
  echo "Помилка: Не вдалося створити повне резервне копіювання."
  exit 1
fi

echo "Відновлення повного резервного копіювання в $FULL_BACKUP_DB..."
mysql -u "$DB_USER" -p"$DB_PASSWORD" "$FULL_BACKUP_DB" < "$FULL_BACKUP_FILE"

if [[ $? -ne 0 ]]; then
  echo "Помилка: Не вдалося відновити повне резервне копіювання."
  exit 1
fi

DATA_BACKUP_FILE="data_backup.sql"
echo "Створення резервного копіювання даних $SOURCE_DB..."
mysqldump -u "$DB_USER" -p"$DB_PASSWORD" --no-create-info "$SOURCE_DB" > "$DATA_BACKUP_FILE"

if [[ $? -ne 0 ]]; then
  echo "Помилка: Не вдалося створити резервне копіювання даних."
  exit 1
fi

echo "Відновлення резервного копіювання даних в $DATA_BACKUP_DB..."
mysql -u "$DB_USER" -p"$DB_PASSWORD" "$DATA_BACKUP_DB" < "$DATA_BACKUP_FILE"

if [[ $? -ne 0 ]]; then
  echo "Помилка: Не вдалося відновити резервне копіювання даних."
  exit 1
fi

echo "Резервне копіювання та відновлення успішно завершено."
