#!bin/sh

echo "Starting container ..."

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
echo "Mounting Webdav ${WEBDAV_HOST}/${WEBDAV_PATH} to /data"
rclone mount --allow-non-empty --vfs-cache-mode writes WEBDAV:/ /data
