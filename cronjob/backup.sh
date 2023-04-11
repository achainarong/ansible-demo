#!/bin/sh

mkdir /backups
cd /backups
APPWRITE_ID=#APPWRITE_ID#

# APPWRITE_VOLUMES = $(ls /var/lib/docker/volumes | grep $APPWRITE_ID)
BACKUP_TIMESTAMP=$(date '+%Y-%m-%dT%H:%M:%S')
BACKUP_FILENAME="backup_$BACKUP_TIMESTAMP.tar.gz"
echo $BACKUP_FILENAME

# add hostname
HOST_NAME=
  
s3cmd put /backups/backups/$BACKUP_FILENAME s3://$HOST_NAME/appwrite-backups/

