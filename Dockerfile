FROM alpine:latest

MAINTAINER Kersten Burkhardt <kersten@beyond-agentur.com>

ENV S3CMD_VERSION 2.0.1

# install s3cmd
RUN apk update && \
    apk add --no-cache bash py-pip py-setuptools ca-certificates openssl

RUN pip install --upgrade pip && \
    pip install python-magic

RUN cd /tmp && \
    wget https://github.com/s3tools/s3cmd/releases/download/v${S3CMD_VERSION}/s3cmd-${S3CMD_VERSION}.tar.gz && \
    tar xzf s3cmd-${S3CMD_VERSION}.tar.gz && \
    cd s3cmd-${S3CMD_VERSION} && \
    python setup.py install

RUN rm -rf /var/cache/apk/* /tmp/s3cmd-${S3CMD_VERSION} /tmp/s3cmd-${S3CMD_VERSION}.tar.gz

RUN pip install s3cmd

ADD s3cfg /root/.s3cfg

ADD start.sh /start.sh
RUN chmod +x /start.sh
ADD backup.sh /backup.sh
RUN chmod +x /backup.sh
ADD restore.sh /restore.sh
RUN chmod +x /restore.sh

ENTRYPOINT ["/start.sh"]
CMD [""]
