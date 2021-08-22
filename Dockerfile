FROM pihole/pihole:master

RUN cd /tmp \
    # Install Cloudflared \
    && curl -OL https://github.com/cloudflare/cloudflared/releases/download/2021.8.2/cloudflared-linux-amd64.deb \
    && apt-get update \
    && apt-get install -y ./cloudflared-linux-amd64.deb stubby \
    && useradd -s /usr/sbin/nologin -r -M cloudflared \
    && chown cloudflared:cloudflared /usr/local/bin/cloudflared \
    && mkdir -p /etc/cloudflared \
    && rm -f /etc/cloudflared/config.yml \
    # Cleanup \
    && apt-get -y autoremove \
    && apt-get -y autoclean \
    && apt-get -y clean \
    && rm -fr /tmp/* /var/tmp/* /var/lib/apt/lists/*

WORKDIR /config

COPY files/s6/ /etc/services.d/pihole-dot-doh/
COPY files/*.yaml /config
