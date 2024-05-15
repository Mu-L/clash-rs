FROM alpine:latest as builder
ARG TARGETPLATFORM
RUN echo "building clash_rs docker image for $TARGETPLATFORM"

# 1. download Country.mmdb
RUN apk add --no-cache gzip && \
    mkdir /clash-rs-config && \
    wget -O /clash-rs-config/Country.mmdb https://github.com/Loyalsoldier/geoip/releases/download/202307271745/Country.mmdb

# 2. mv the binary to /clash-rs/clash_rs
WORKDIR /clash-rs
COPY bin/ /clash-rs/bin/
COPY docker/platform2name.sh /clash-rs/platform2name.sh

# 3. get the file name
RUN FILE_NAME=`sh /clash-rs/platform2name.sh` && echo $FILE_NAME && \
    FILE_NAME=`ls bin/ | egrep "$FILE_NAME" | awk NR==1` && echo $FILE_NAME && \
    mv bin/$FILE_NAME clash_rs
FROM alpine:latest
LABEL org.opencontainers.image.source="https://github.com/Watfaq/clash-rs"

# 3. install deps
RUN apk add --no-cache ca-certificates tzdata iptables

VOLUME ["/root/.config/clash-rs/"]

# 4. copy files
COPY --from=builder /clash-rs-config/ /root/.config/clash-rs/
COPY --from=builder /clash-rs/clash_rs /clash_rs
RUN chmod +x /clash_rs
ENTRYPOINT [ "/clash_rs", "-d", "/root/.config/clash-rs/", "-f", "config.yaml"]
