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
