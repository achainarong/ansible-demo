#/bin/bash

mkdir /backups
cd /backups
APPWRITE_ID="cl8amjii00580ctmty6796pxb"

# APPWRITE_VOLUMES = $(ls /var/lib/docker/volumes | grep $APPWRITE_ID)
BACKUP_TIMESTAMP=$(date '+%Y-%m-%dT%H:%M:%S')
BACKUP_FILENAME="backup_$BACKUP_TIMESTAMP.tar.gz"
echo $BACKUP_FILENAME

docker run --rm \
  -v $APPWRITE_ID-mariadb:/backup/appwrite-mariadb \
  -v $APPWRITE_ID-redis:/backup/appwrite-redis \
  -v $APPWRITE_ID-cache:/backup/appwrite-cache \
  -v $APPWRITE_ID-uploads:/backup/appwrite-uploads \
  -v $APPWRITE_ID-certificates:/backup/appwrite-certificates \
  -v $APPWRITE_ID-functions:/backup/appwrite-functions \
  -v $APPWRITE_ID-influxdb:/backup/appwrite-influxdb \
  -v $APPWRITE_ID-config:/backup/appwrite-config \
  -v $APPWRITE_ID-builds:/backup/appwrite-builds \
  -v $APPWRITE_ID-executor:/backup/appwrite-executor \
  -v $(pwd)/.env:/backup/appwrite/.env \
  -v $(pwd)/docker-compose.yml:/backup/appwrite/docker-compose.yml \
  -v $(pwd)/backups:/archive \
  --env BACKUP_FILENAME=$BACKUP_FILENAME\
  --entrypoint backup \
  offen/docker-volume-backup:latest

# add hostname
HOST_NAME=

s3cmd put /backups/backups/$BACKUP_FILENAME s3://$HOST_NAME/appwrite-backups/

