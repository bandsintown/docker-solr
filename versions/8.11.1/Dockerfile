FROM bandsintown/openjdk:8-jre-alpine-3-15
LABEL maintainer="Bandsintown Devops Team <devops@bandsintown.com>"

COPY rootfs /

# Override the solr download location with e.g.:
#   docker build -t mine --build-arg SOLR_DOWNLOAD_SERVER=http://www-eu.apache.org/dist/lucene/solr .
ARG SOLR_DOWNLOAD_SERVER

RUN set -ex; \
  apk update; \
  apk add acl dirmngr gpg lsof procps wget tini; \
  rm -rf /var/lib/apt/lists/*; \
  cd /usr/local/bin; wget -nv https://github.com/apangin/jattach/releases/download/v1.5/jattach; chmod 755 jattach; \
  echo >jattach.sha512 "d8eedbb3e192a8596c08efedff99b9acf1075331e1747107c07cdb1718db2abe259ef168109e46bd4cf80d47d43028ff469f95e6ddcbdda4d7ffa73a20e852f9  jattach"; \
  sha512sum -c jattach.sha512; rm jattach.sha512

RUN apk add --no-cache \
        lsof \
        gnupg \
        procps \
        tar \
        bash \
        su-exec
RUN apk add --no-cache ca-certificates wget && \
        update-ca-certificates

ENV SOLR_USER="solr" \
    SOLR_UID="8983" \
    SOLR_GROUP="solr" \
    SOLR_GID="8983" \
    SOLR_CLOSER_URL="http://www.apache.org/dyn/closer.lua?filename=lucene/solr/$SOLR_VERSION/solr-$SOLR_VERSION.tgz&action=download" \
    SOLR_DIST_URL="https://www.apache.org/dist/lucene/solr/$SOLR_VERSION/solr-$SOLR_VERSION.tgz" \
    SOLR_ARCHIVE_URL="https://archive.apache.org/dist/lucene/solr/$SOLR_VERSION/solr-$SOLR_VERSION.tgz" \
    PATH="/opt/solr/bin:/opt/docker-solr/scripts:$PATH" \
    SOLR_INCLUDE=/etc/default/solr.in.sh \
    SOLR_HOME=/var/solr/data \
    SOLR_PID_DIR=/var/solr \
    SOLR_LOGS_DIR=/var/solr/logs \
    LOG4J_PROPS=/var/solr/log4j2.xml

#RUN set -ex; \
#  addgroup -S --g "$SOLR_GID" "$SOLR_GROUP"; \
#  useradd -S -u "$SOLR_UID" -G "$SOLR_USER" "$SOLR_GID" "$SOLR_USER"

RUN addgroup -S -g $SOLR_UID $SOLR_USER && \
  adduser -S -u $SOLR_UID -G $SOLR_USER -g $SOLR_USER $SOLR_USER

ENV SOLR_VERSION 8.11.1
ENV SERVICE_NAME="solr" SERVICE_VERSION="${SOLR_VERSION}"
ENV SOLR_URL ${SOLR_DOWNLOAD_SERVER:-https://archive.apache.org/dist/lucene/solr}/$SOLR_VERSION/solr-$SOLR_VERSION.tgz
ENV SOLR_SHA512 4893f836aec84b03d7bfe574e59e305c03b5ede4a48020034fbe81440b8feee79e55fd9ead230e5b89b3f25124e9b56c1ddc4bb5c7f631cf4e846b9cab5f9a45
ENV SOLR_KEYS 2CECBFBA181601547B654B9FFA81AC8A490F538E

#RUN set -ex; \
#  export GNUPGHOME="/tmp/gnupg_home"; \
#  mkdir -p "$GNUPGHOME"; \
#  chmod 700 "$GNUPGHOME"; \
#  echo "disable-ipv6" >> "$GNUPGHOME/dirmngr.conf"; \
#  for key in $SOLR_KEYS; do \
#    found=''; \
#    for server in \
#      ha.pool.sks-keyservers.net \
#      hkp://keyserver.ubuntu.com:80 \
#      hkp://p80.pool.sks-keyservers.net:80 \
#      pgp.mit.edu \
#    ; do \
#      echo "  trying $server for $key"; \
#      gpg --batch --keyserver "$server" --keyserver-options timeout=10 --recv-keys "$key" && found=yes && break; \
#      gpg --batch --keyserver "$server" --keyserver-options timeout=10 --recv-keys "$key" && found=yes && break; \
#    done; \
#    test -z "$found" && echo >&2 "error: failed to fetch $key from several disparate servers -- network issues?" && exit 1; \
#  done; \
#  exit 0

RUN set -e; for key in $SOLR_KEYS; do \
    found=''; \
    for server in \
      ha.pool.sks-keyservers.net \
      hkp://keyserver.ubuntu.com:80 \
      hkp://p80.pool.sks-keyservers.net:80 \
      pgp.mit.edu \
    ; do \
      echo "  trying $server for $key"; \
      gpg --keyserver "$server" --keyserver-options timeout=10 --recv-keys "$key" && found=yes && break; \
    done; \
    test -z "$found" && echo >&2 "error: failed to fetch $key from several disparate servers -- network issues?" && exit 1; \
  done; \
  exit 0

RUN mkdir -p /opt/solr && \
  echo "downloading $SOLR_URL" && \
  wget -q $SOLR_URL -O /opt/solr.tgz && \
  echo "downloading $SOLR_URL.asc" && \
  wget -q $SOLR_URL.asc -O /opt/solr.tgz.asc && \
  echo "$SOLR_SHA512 */opt/solr.tgz" | sha512sum -c - && \
  (>&2 ls -l /opt/solr.tgz /opt/solr.tgz.asc) && \
  gpg --batch --verify /opt/solr.tgz.asc /opt/solr.tgz && \
  tar -C /opt/solr --extract --file /opt/solr.tgz --strip-components=1 && \
  rm /opt/solr.tgz* && \
  rm -Rf /opt/solr/docs/ && \
  mkdir -p /opt/solr/server/solr/lib /opt/solr/server/solr/mycores && \
  sed -i -e 's/#SOLR_PORT=8983/SOLR_PORT=8983/' /opt/solr/bin/solr.in.sh && \
  sed -i -e '/-Dsolr.clustering.enabled=true/ a SOLR_OPTS="$SOLR_OPTS -Dsun.net.inetaddr.ttl=60 -Dsun.net.inetaddr.negative.ttl=60"' /opt/solr/bin/solr.in.sh && \
  chown -R $SOLR_USER:$SOLR_USER /opt/solr && \
  mkdir /docker-entrypoint-initdb.d && \
  echo -ne "- with Solr: $SERVICE_VERSION\n" >> /root/.built

RUN chown -R $SOLR_USER:$SOLR_USER /opt/docker-solr

ENV PATH /opt/solr/bin:/opt/docker-solr/scripts:$PATH

EXPOSE 8983
WORKDIR /opt/solr

ENTRYPOINT ["/init"]
CMD ["su-exec", "solr", "solr-foreground"]