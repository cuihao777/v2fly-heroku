FROM nginx

LABEL maintainer="[Trojan & V2ray & Nginx] Maintainers <cuihao871120@gmail.com>"

ENV V2RAY_VERSION 4.27.5

RUN apt-get update && \
    apt-get install curl -y && \
    apt-get install --no-install-recommends --no-install-suggests -y wget xz-utils git unzip

COPY --from=ochinchina/supervisord:latest /usr/local/bin/supervisord /usr/bin/supervisord
COPY entrypoint.sh /usr/bin/entrypoint.sh

RUN curl -L -o /tmp/v2ray.zip https://github.com/v2fly/v2ray-core/releases/download/v${V2RAY_VERSION}/v2ray-linux-64.zip && \
    unzip -d /tmp/v2ray /tmp/v2ray.zip && \
    mkdir /usr/bin/v2ray && \
    mkdir /opt/config && \
    mv /tmp/v2ray/v2ray /usr/bin/v2ray/v2ray && \
    mv /tmp/v2ray/v2ctl /usr/bin/v2ray/v2ctl && \
    mv /tmp/v2ray/geoip.dat /usr/bin/v2ray/geoip.dat && \
    mv /tmp/v2ray/geosite.dat /usr/bin/v2ray/geosite.dat && \
    chmod +x /usr/bin/v2ray/v2ray && \
    chmod +x /usr/bin/v2ray/v2ctl && \
    chmod +x /usr/bin/entrypoint.sh && \
    rm /tmp -rf

COPY ./config/v2ray.json /opt/template/v2ray.json
COPY ./config/nginx.conf /opt/template/nginx.conf
COPY ./config/supervisor.conf /etc/supervisor.conf

COPY ./nginx/html/index.html /var/www/html/index.html

ENV UUID 7336e9a8-4090-a66a-398d-7ae1a66bb4d8
ENV PORT 80
ENV PATH /usr/bin/:/usr/local/bin:/usr/bin/v2ray:$PATH

STOPSIGNAL SIGKILL

CMD ["/usr/bin/entrypoint.sh"]