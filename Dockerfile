FROM alpine:latest

# add fuse
RUN apk add --update --no-cache fuse

# Get rclone executable
ADD https://downloads.rclone.org/rclone-current-linux-amd64.zip /
RUN unzip rclone-current-linux-amd64.zip && mv rclone-*-linux-amd64/rclone /bin/rclone && chmod +x /bin/rclone

# Webdav env
ENV WEBDAV_HOST=""
ENV WEBDAV_PATH=""
ENV WEBDAV_USER=""
ENV WEBDAV_PASSWORD=""

# /data is the dir which will be mounted
RUN mkdir /data

COPY entry.sh /entry.sh

WORKDIR "/"
ENTRYPOINT ["/entry.sh"]
