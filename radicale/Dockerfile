ARG BUILD_FROM=hassioaddons/base:8.0.6
# hadolint ignore=DL3006
FROM ${BUILD_FROM}

# Set shell
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Setup base
# hadolint ignore=DL3003
RUN apk add --no-cache --virtual .build-dependencies \
        build-base=0.5-r2 \
        libffi-dev=3.3-r2 \
        python3-dev=3.8.5-r0 \
        py3-wheel=0.34.2-r1 \
        py3-pip=20.1.1-r0
RUN apk add -v -v --no-cache python3=3.8.5-r0 py3-setuptools=47.0.0-r0
RUN python3 -m pip install radicale[bcrypt]==3.0.6
RUN apk del --no-cache --purge .build-dependencies
RUN rm -fr /root/.cache

# Copy root filesystem
COPY rootfs /

EXPOSE 5232

# Build arguments
ARG BUILD_ARCH
ARG BUILD_DATE
ARG BUILD_REF
ARG BUILD_VERSION

# Labels
LABEL \
    io.hass.name="Radicale" \
    io.hass.description="Free and Open-Source CalDAV and CardDAV Server" \
    io.hass.arch="${BUILD_ARCH}" \
    io.hass.type="addon" \
    io.hass.version=${BUILD_VERSION} \
    maintainer="Morten <221842+buhl@users.noreply.github.com>" \
    org.opencontainers.image.title="Radicale" \
    org.opencontainers.image.description="Free and Open-Source CalDAV and CardDAV Server" \
    org.opencontainers.image.vendor="Home Assistant Community Add-ons" \
    org.opencontainers.image.authors="Morten <221842+buhl@users.noreply.github.com>" \
    org.opencontainers.image.licenses="add-on: MIT, Radicale:GPLv3" \
    org.opencontainers.image.url="https://addons.community" \
    org.opencontainers.image.source="https://github.com/buhl/HAOS-addon-radicale" \
    org.opencontainers.image.documentation="https://github.com/buhl/HAOS-addon-radicale/blob/master/README.md" \
    org.opencontainers.image.created=${BUILD_DATE} \
    org.opencontainers.image.revision=${BUILD_REF} \
    org.opencontainers.image.version=${BUILD_VERSION}
