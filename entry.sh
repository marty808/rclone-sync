#!bin/sh

echo "Starting container ..."

# umask 
umask $UMASK

if [ -n "${WEBDAV_HOST}" ]; then
   echo "WEBDAV enabled: ${WEBDAV_HOST}/${WEBDAV_PATH}"
else
   echo "Webdav enabled BUT no HOST provided. Please use Environment Variables... exiting"
   exit 2
fi
if [ -n "${WEBDAV_USER}" ] && [ -n "${WEBDAV_PASSWORD}" ]; then
   echo "Webdav enabled with Credentials provided."
else
   echo "Webdav enabled BUT no Credentials provided. Please use Environment Variables... exiting"
   exit 2
fi

echo "creating rclone remote config"
rclone config create WEBDAV webdav vendor nextcloud url ${WEBDAV_HOST}/${WEBDAV_PATH} user ${WEBDAV_USER} pass ${WEBDAV_PASSWORD}

if [ ${RCLONE_INIT} ]; then
   echo "copy initial data from Webdav ${WEBDAV_HOST}/${WEBDAV_PATH} to /data"
<<<<<<< HEAD
   rclone copy WEBDAV:/ /data
fi

# build command for RCLONE
cmd="/bin/rclone ${RCLONE_MODE} /data WEBDAV:/"
=======
   rclone copy --umask=$UMASK WEBDAV:/ /data
fi

# build command for RCLONE
cmd="/bin/rclone ${RCLONE_MODE} --umask=$UMASK /data WEBDAV:/"
>>>>>>> 00fe2fd3ed7a3f7b7c2c89f51684411284ba7ec5

echo "Setup backup cron job with cron schedule: ${CRON_SChEDULE}"
echo "${CRON_SCHEDULE} /usr/bin/flock -n /var/run/backup.lock ${cmd} >> /var/log/cron.log 2>&1" > /var/spool/cron/crontabs/root

# Make sure the file exists before we start tail
touch /var/log/cron.log

# start the cron deamon
crond

echo "Container started."

# create file for health check
touch /run/ready

exec "$@"
