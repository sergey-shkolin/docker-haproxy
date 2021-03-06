FROM oberthur/docker-ubuntu:14.04.4

MAINTAINER Dawid Malinowski <d.malinowski@oberthur.com>

ENV HAPROXY_VERSION=1.6.7 \
    START_MODE=haproxy

COPY haproxy.cfg /etc/haproxy/haproxy.cfg.template
COPY start-*.sh /bin/
COPY supervisor.conf /etc/supervisor/conf.d/haproxy.conf

# Prepare image
RUN chmod +x /bin/start-*.sh \
    && add-apt-repository ppa:vbernat/haproxy-1.6 \
    && apt-get update \
    && apt-get install rsyslog supervisor haproxy=${HAPROXY_VERSION}* \
    && apt-get clean autoclean \
    && apt-get autoremove --yes \
    && rm -rf /var/lib/{apt,dpkg,cache,log}/ \
    && ln -sf /dev/stdout /var/log/haproxy.log

COPY haproxy.rsyslog /etc/rsyslog.conf

ENTRYPOINT ["/usr/bin/supervisord","-n","-c","/etc/supervisor/supervisord.conf"]
