BACKUP_FILENAME=$1
APPWRITE_ID=$2

tar -C /tmp -xvf $BACKUP_FILENAME

# Restore volumes and configuration
docker run -d --name temp_restore_container \
  -v $APPWRITE_ID-mariadb:/backup_restore/appwrite-mariadb \
  -v $APPWRITE_ID-redis:/backup_restore/appwrite-redis \
  -v $APPWRITE_ID-cache:/backup_restore/appwrite-cache \
  -v $APPWRITE_ID-uploads:/backup_restore/appwrite-uploads \
  -v $APPWRITE_ID-certificates:/backup_restore/appwrite-certificates \
  -v $APPWRITE_ID-functions:/backup_restore/appwrite-functions \
  -v $APPWRITE_ID-influxdb:/backup_restore/appwrite-influxdb \
  -v $APPWRITE_ID-config:/backup_restore/appwrite-config \
  -v $APPWRITE_ID-builds:/backup_restore/appwrite-builds \
  -v $APPWRITE_ID-executor:/backup_restore/appwrite-executor \
  -v $(pwd)/appwrite:/backup_restore/appwrite \
  alpine tail -f /dev/null

docker cp /tmp/backup/. temp_restore_container:/backup_restore

docker stop temp_restore_container
docker rm temp_restore_container

# Remove temporary files
rm -rf /tmp/backup
