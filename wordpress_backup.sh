#!/bin/sh

PROJECT_NAME="mads"
PROJECT_DIR="/var/www/mads"
BACKUP_ROOT_DIR="/home/backup"
BACKUP_EXPIRED_TIME=60
TMP_DIR="tmp"

BACKUP_TMP_DIR=""
PROJECT_TMP_DIR=""
BACKUP_DATE=$(date +"%Y-%m-%d")
