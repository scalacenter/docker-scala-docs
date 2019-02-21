FROM frolvlad/alpine-glibc:alpine-3.9_glibc-2.28

# Set environment
ENV JAVA_HOME /usr/lib/jvm/jdk8
ENV PATH $PATH:$JAVA_HOME/bin

RUN apk add --update --no-cache bash
RUN apk add --no-cache --virtual=build-dependencies wget curl binutils ca-certificates \
  && mkdir /usr/lib/jvm

RUN curl -sL https://github.com/shyiko/jabba/raw/master/install.sh | \
    JABBA_COMMAND="install adopt@1.8.202-08 -o /usr/lib/jvm/jdk8" bash

RUN curl -sL https://github.com/shyiko/jabba/raw/master/install.sh | \
    JABBA_COMMAND="install adopt@1.10.0-2 -o /usr/lib/jvm/jdk10" bash

RUN JDK11_URL="https://github.com/AdoptOpenJDK/openjdk11-binaries/releases/download/jdk11u-2019-02-20-11-53/OpenJDK11U-jdk_x64_linux_hotspot_2019-02-20-11-53.tar.gz" \
    && JDK11_SHA256=35465cc7319ad4d790c540628033c14b10fa98f2006eb4dcaf886f169e5dd8e7 \
    && curl -Ls ${JDK11_URL} -o /tmp/jdk11.tar.gz \
    && echo "${JDK11_SHA256}  /tmp/jdk11.tar.gz" | sha256sum -c - \
    && mkdir -p /usr/lib/jvm/jdk11 \
    && tar -xf /tmp/jdk11.tar.gz -C /usr/lib/jvm/jdk11 --strip-components=1 \
    && rm /tmp/jdk11.tar.gz

WORKDIR /

# Set environment
ENV UNDERLYING_SBT /usr/lib/bin/sbt

# Install packages
RUN ZLIB_URL="https://archive.archlinux.org/packages/z/zlib/zlib-1%3A1.2.9-1-x86_64.pkg.tar.xz" \
    && ZLIB_SHA256=bb0959c08c1735de27abf01440a6f8a17c5c51e61c3b4c707e988c906d3b7f67 \
    && curl -Ls ${ZLIB_URL} -o /tmp/libz.tar.xz \
    && echo "${ZLIB_SHA256}  /tmp/libz.tar.xz" | sha256sum -c - \
    && mkdir /tmp/libz \
    && tar -xf /tmp/libz.tar.xz -C /tmp/libz \
    && mv /tmp/libz/usr/lib/libz.so* /usr/glibc-compat/lib \
    && rm -rf /tmp/libz /tmp/libz.tar.xz

RUN apk add --no-cache git
RUN apk add --no-cache openssh
RUN apk add --no-cache openssl
RUN apk add --no-cache curl
RUN apk add --no-cache jq
RUN apk add --no-cache ruby
RUN apk add --no-cache ruby-bundler ruby-dev ruby-irb ruby-rdoc libatomic readline readline-dev \
    libxml2 libxml2-dev libxslt libxslt-dev zlib-dev zlib libffi-dev build-base nodejs
RUN apk add --no-cache hugo
RUN apk add --no-cache python2
RUN apk add --no-cache clang
RUN apk add --no-cache gc-dev
RUN apk add --no-cache libunwind-dev
RUN apk add --no-cache re2-dev
RUN apk add --no-cache libc-dev
RUN apk add --no-cache musl-dev

# Install jekyll and sass just in case they are required
RUN export PATH="/root/.rbenv/bin:$PATH"
RUN gem update --system
RUN gem install sass
RUN gem install jekyll

RUN mkdir /usr/lib/bin
RUN curl -s https://raw.githubusercontent.com/paulp/sbt-extras/master/sbt > /usr/lib/bin/sbt
RUN chmod 0755 /usr/lib/bin/sbt

# Add all scripts in image
COPY bin /usr/local/bin
COPY sbt.boot /sbt.boot

# Copy our custom sbt to the default location, replace previous
RUN mv /usr/local/bin/sbt /usr/bin/sbt
#RUN $UNDERLYING_SBT about -sbt-create -Dsbt.boot.properties=/sbt.boot

# Remove dependencies
RUN apk del build-dependencies

# Set up and warm up sbt
#RUN git clone https://github.com/scalaplatform/warm-sbt && cd warm-sbt && git checkout v0.3.0 && $UNDERLYING_SBT "+run" -Dsbt.boot.properties=/sbt.boot && cd .. && rm -rf warm-sbt
#RUN mv /root/.sbt/* /drone/.sbt
#RUN rm -rf /root/.sbt

# Set up and test a Scala native project
#RUN $UNDERLYING_SBT -Dsbt.boot.properties=/sbt.boot new scala-native/scala-native.g8 --name=seed && cd seed && $UNDERLYING_SBT "run" -Dsbt.boot.properties=/sbt.boot && cd .. && rm -rf seed

# Save some space
RUN rm -rf /tmp/*
#RUN mv /root/.coursier/* /drone/.coursier
RUN mkdir -p /drone/.coursier
RUN rm -rf /root/.coursier
