FROM alpine:latest

# Get rclone executable
ADD https://downloads.rclone.org/rclone-current-linux-amd64.zip /
RUN unzip rclone-current-linux-amd64.zip && mv rclone-*-linux-amd64/rclone /bin/rclone && chmod +x /bin/rclone

# Webdav env
ENV WEBDAV_HOST=""
ENV WEBDAV_PATH=""
ENV WEBDAV_USER=""
ENV WEBDAV_PASSWORD=""
# modes are sync or copy
ENV RCLONE_MODE="sync"
# INIT could be COPY or NONE
ENV RCLONE_INIT=true
# cron schedule default every minute
ENV CRON_SCHEDULE="*/1 * * * *"


# create needed directories
RUN mkdir -p /data /var/spool/cron/crontabs /var/log; \
    touch /var/log/cron.log;


COPY entry.sh /entry.sh

WORKDIR "/"
ENTRYPOINT ["/entry.sh"]

HEALTHCHECK CMD test -f /run/ready 

CMD ["tail","-fn0","/var/log/cron.log"]
