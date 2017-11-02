FROM alpine

MAINTAINER storezhang "storezhang@gmail.com"

ENV SSR_DATA="/ssr-data"

EXPOSE 1081

RUN set -x \
    && echo -e "https://mirrors.ustc.edu.cn/alpine/latest-stable/main\nhttps://mirrors.ustc.edu.cn/alpine/latest-stable/community" > /etc/apk/repositories \
    && apk update \
    && apk --no-cache add su-exec python supervisor \
    && mkdir -p /etc/polipo \
    && adduser -S -h ${SSR_DATA} ssr \
    && mkdir -p "${SSR_DATA}" \
    && chown -R ssr "${SSR_DATA}"

VOLUME ${SSR_DATA}
WORKDIR ${SSR_DATA}

COPY ./shadowsocks ${SSR_DATA}/shadowsocks
ADD ./polipo/polipo /usr/bin/polipo
ADD ./polipo/config ${SSR_DATA}/polipo/config
ADD ./supervisord.conf ${SSR_DATA}/supervisord.conf

ENTRYPOINT ["supervisord", "-c", "${SSR_DATA}/supervisord.conf"]
