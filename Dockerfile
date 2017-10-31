FROM alpine

MAINTAINER storezhang "storezhang@gmail.com"

ENV CASH_AGENT_DATA="/cash-agent-data"

RUN set -x \
    && echo -e "https://mirrors.ustc.edu.cn/alpine/latest-stable/main\nhttps://mirrors.ustc.edu.cn/alpine/latest-stable/community" > /etc/apk/repositories \
    && apk update \
    && apk --no-cache add \
        openjdk8-jre-base \
        su-exec \
    && adduser -S -h ${CASH_AGENT_DATA} cash-agent \
    && mkdir -p "${CASH_AGENT_DATA}" \
    && chown -R cash-agent "${CASH_AGENT_DATA}"

VOLUME ${CASH_AGENT_DATA}
ADD ./shadowsocks shadowsocks

WORKDIR ${CASH_AGENT_DATA}

CMD ["su-exec", "cash-agent", "java", "-jar", "/app.jar"]