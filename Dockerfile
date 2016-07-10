FROM joshdev/alpine-oraclejdk8

# Set environment
ENV SBT_HOME /usr/lib/sbt
ENV PATH $PATH:$SBT_HOME/bin

RUN apk add --no-cache bash \
  && apk add --no-cache --virtual=build-dependencies wget ca-certificates \
  && cd /usr/lib \
  && wget -q --no-cookies https://dl.bintray.com/sbt/native-packages/sbt/0.13.11/sbt-0.13.11.tgz -O - | gunzip | tar x \
  && apk del build-dependencies \
  && rm -rf /tmp/*
