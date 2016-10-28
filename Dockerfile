FROM joshdev/alpine-oraclejdk8:8u102

# Set environment
ENV SBT_HOME /usr/lib/sbt
ENV PATH $PATH:$SBT_HOME/bin

RUN apk add --no-cache bash \
  && apk add --no-cache --virtual=build-dependencies wget ca-certificates \
  && apk add --no-cache git \
  && apk add --no-cache curl \
  && apk add --no-cache ruby ruby-bundler ruby-dev ruby-irb ruby-rdoc libatomic readline readline-dev \
    libxml2 libxml2-dev libxslt libxslt-dev zlib-dev zlib libffi-dev build-base nodejs \
  && export PATH="/root/.rbenv/bin:$PATH" \
  && gem update --system \
  && gem install sass \
  && gem install jekyll -v 3.2.1 \
  && mkdir /usr/lib/bin \
  && curl -s https://raw.githubusercontent.com/paulp/sbt-extras/master/sbt > /usr/lib/bin/sbt \
  && chmod 0755 /usr/lib/bin/sbt \
  && mv /usr/lib/bin/sbt /usr/bin/sbt \
  && /usr/bin/sbt about -sbt-create \
  && apk del build-dependencies \
  && apk del build-base zlib-dev ruby-dev readline-dev libffi-dev libxml2-dev \
  && rm -rf /tmp/*
