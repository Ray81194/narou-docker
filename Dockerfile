# ---- Builder stage ----
FROM ruby:3.1.7-alpine AS builder

ENV NAROU_VERSION 3.9.1
ENV AOZORAEPUB3_VERSION 1.1.1b30Q
ENV AOZORAEPUB3_FILE AozoraEpub3-${AOZORAEPUB3_VERSION}

WORKDIR /temp

# build に必要なパッケージを入れる
RUN apk add --no-cache --virtual .build-deps \
      build-base \
      make \
      gcc \
      git

# install AozoraEpub3
RUN wget https://github.com/kyukyunyorituryo/AozoraEpub3/releases/download/v${AOZORAEPUB3_VERSION}/${AOZORAEPUB3_FILE}.zip \
 && unzip -q ${AOZORAEPUB3_FILE} -d /aozoraepub3

# narou install
COPY install.sh .
RUN chmod +x install.sh && ./install.sh

# ---- Runtime stage ----
FROM ruby:3.1.7-alpine

# ランタイムに必要な最低限だけ残す
RUN apk add --no-cache \
      openjdk21-jre-headless \
      libc6-compat \
      libstdc++

# builder から必要な成果物だけコピー
COPY --from=builder /usr/local/bundle /usr/local/bundle
COPY --from=builder /aozoraepub3 /aozoraepub3

WORKDIR /novel

COPY init.sh /usr/local/bin
RUN chmod +x /usr/local/bin/init.sh

EXPOSE 33000-33001
ENTRYPOINT ["init.sh"]
