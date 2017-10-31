FROM alpine

MAINTAINER storezhang "storezhang@gmail.com"

ENV SSR_DATA="/ssr-data"

RUN set -x \
    && echo -e "https://mirrors.ustc.edu.cn/alpine/latest-stable/main\nhttps://mirrors.ustc.edu.cn/alpine/latest-stable/community" > /etc/apk/repositories \
    && apk update \
    && apk --no-cache add su-exec python \
    && mkdir -p /etc/polipo \
    && mkdir /cache \
    && adduser -S -h ${SSR_DATA} ssr \
    && mkdir -p "${SSR_DATA}" \
    && chown -R ssr "${SSR_DATA}"

VOLUME ${SSR_DATA}
ADD ./shadowsocks shadowsocks
ADD ./polipo/polipo /usr/bin/polipo
ADD ./polipo/config /etc/polipo/config

WORKDIR ${SSR_DATA}

CMD ["su-exec", "ssr", "java", "-jar", "/app.jar"]