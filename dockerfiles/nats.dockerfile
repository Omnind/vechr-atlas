ARG NATS_VERSION
FROM nats:${NATS_VERSION}

COPY config/standalone.conf /standalone.conf

CMD ["-c", "/standalone.conf"]