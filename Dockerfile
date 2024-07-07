FROM ruby:3.3.3-alpine

ENV NAROU_VERSION 3.9.0
ENV AOZORAEPUB3_VERSION 1.1.1b24Q
ENV AOZORAEPUB3_FILE AozoraEpub3-${AOZORAEPUB3_VERSION}

WORKDIR /temp

RUN set -x \
 # install AozoraEpub3
 && wget https://github.com/kyukyunyorituryo/AozoraEpub3/releases/download/v${AOZORAEPUB3_VERSION}/${AOZORAEPUB3_FILE}.zip \
 && unzip -q ${AOZORAEPUB3_FILE} -d /aozoraepub3 \
 # install openjdk21
 && apk --no-cache add openjdk21 \
 # install Narou.rb
 && apk --update --no-cache --virtual .build-deps add \
      build-base \
      make \
      gcc \
 && gem install narou -v ${NAROU_VERSION} --no-document \
 && apk del --purge .build-deps \
 # setting AozoraEpub3
 && mkdir .narousetting \
 && narou init -p /aozoraepub3 -l 1.8 \
 && rm -rf /temp

WORKDIR /novel

COPY init.sh /usr/local/bin
RUN chmod +x /usr/local/bin/init.sh

EXPOSE 33000-33001

ENTRYPOINT ["init.sh"]
CMD ["narou", "web", "-np", "33000"]
