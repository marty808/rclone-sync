FROM alpine:latest

# Get rclone executable
ADD https://downloads.rclone.org/rclone-current-linux-amd64.zip /
RUN unzip rclone-current-linux-amd64.zip && mv rclone-*-linux-amd64/rclone /bin/rclone && chmod +x /bin/rclone

# Webdav env
ENV WEBDAV_HOST=""
ENV WEBDAV_PATH=""
ENV WEBDAV_USER=""
ENV WEBDAV_PASSWORD=""
# modes are SYNC or COPY
ENV RCLONE_MODE="SYNC"
# INIT could be COPY or NONE
ENV RCLONE_INIT="COPY"
# cron schedule default every minute
ENV CRON_SCHEDULE="*/1 * * * *"


# create crontabs etc.
RUN mkdir -p /var/spool/cron/crontabs /var/log; \
    touch /var/log/cron.log;


# /data is the dir which will be mounted
RUN mkdir /data

COPY entry.sh /entry.sh

WORKDIR "/"
ENTRYPOINT ["/entry.sh"]
CMD ["tail","-fn0","/var/log/cron.log"]
