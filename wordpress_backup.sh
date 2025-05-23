#!/bin/sh

PROJECT_NAME="mads"
PROJECT_DIR="/var/www/mads"
BACKUP_ROOT_DIR="/home/backup"
BACKUP_EXPIRED_TIME=60
TMP_DIR="tmp"

BACKUP_TMP_DIR=""
PROJECT_TMP_DIR=""
BACKUP_DATE=$(date +"%Y-%m-%d")


if [ $(echo $TMP_DIR | cut -b 1) = "/" ]; then
  BACKUP_TMP_DIR=$TMP_DIR
else
  BACKUP_TMP_DIR=$BACKUP_ROOT_DIR/$TMP_DIR
fi

PROJECT_TMP_DIR=$BACKUP_TMP_DIR/$PROJECT_NAME

if [ -d $PROJECT_TMP_DIR ]; then
  rm -r $PROJECT_TMP_DIR
fi
mkdir $PROJECT_TMP_DIR

mkdir $PROJECT_TMP_DIR/var
mkdir $PROJECT_TMP_DIR/db
cp -r -p $PROJECT_DIR/* $PROJECT_TMP_DIR/var/
cp -p $PROJECT_DIR/.htaccess $PROJECT_TMP_DIR/var/

mysqldump --no-tablespaces \
          --single-transaction \
          --user=$(cat $PROJECT_DIR/wp-config.php | sed -ne "s/^define('DB_USER', '\(.*\)');.*$/\1/p") \
          --password=$(cat $PROJECT_DIR/wp-config.php | sed -ne "s/^define('DB_PASSWORD', '\(.*\)');.*$/\1/p") \
          $(cat $PROJECT_DIR/wp-config.php | sed -ne "s/^define('DB_NAME', '\(.*\)');.*$/\1/p") > $PROJECT_TMP_DIR/db/$PROJECT_NAME.sql

BACKUP_FILE_NAME="$PROJECT_NAME"_$BACKUP_DATE.zip
BACKUP_FILE_PATH=$BACKUP_ROOT_DIR/$BACKUP_FILE_NAME

if [ -f $BACKUP_FILE_PATH ]; then
  rm $BACKUP_FILE_PATH
fi

cd $BACKUP_TMP_DIR/
zip -r $BACKUP_FILE_PATH $PROJECT_NAME
chmod 400 $BACKUP_FILE_PATH

rm -r $PROJECT_TMP_DIR

find $BACKUP_ROOT_DIR -name "$PROJECT_NAME*.zip" -type f -mtime +$BACKUP_EXPIRED_TIME -delete
