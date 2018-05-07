FROM alpine:3.7
LABEL maintainer "Levent SAGIROGLU <LSagiroglu@gmail.com>"
ENV PROFTPD_VERSION 1.3.6

RUN apk add --no-cache --virtual .persistent-deps ca-certificates curl \
    && apk add --no-cache --virtual .build-deps g++ gcc libc-dev make \
    && curl -fSL ftp://ftp.proftpd.org/distrib/source/proftpd-${PROFTPD_VERSION}.tar.gz -o proftpd.tgz \
    && tar -xf proftpd.tgz \
    && rm proftpd.tgz \
    && mkdir -p /usr/local \
    && mv proftpd-${PROFTPD_VERSION} /usr/local/proftpd \
    && sleep 1 \
    && cd /usr/local/proftpd \
    && ./configure \
    && make \
    && cd /usr/local/proftpd && make install \
    && make clean \
    && apk del .build-deps

EXPOSE 20
EXPOSE 21
COPY bin /bin
COPY etc /usr/local/etc
RUN chmod 440 /usr/local/etc/ftpd.passwd
VOLUME /shared 
ENV FTP_CFG "/usr/local/etc/proftpd.conf"

ENTRYPOINT ["/bin/entrypoint.sh"]


# ftpasswd --passwd --file=/usr/local/etc/ftpd.passwd --name=tester --uid=33 --gid=33 --home=/shared --shell=/bin/false
