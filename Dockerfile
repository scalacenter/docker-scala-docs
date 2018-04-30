FROM frolvlad/alpine-glibc:alpine-3.7

# Set environment
ENV JAVA_HOME /usr/lib/jvm/jdk8
ENV PATH $PATH:$JAVA_HOME/bin

RUN apk add --no-cache --virtual=build-dependencies wget ca-certificates \
  && mkdir /usr/lib/jvm

WORKDIR /usr/lib/jvm

# Install JDK8 as the default JDK
RUN wget --no-check-certificate -c --header "Cookie: oraclelicense=accept-securebackup-cookie" http://download.oracle.com/otn-pub/java/jdk/8u162-b12/0da788060d494f5095bf8624735fa2f1/jdk-8u162-linux-x64.tar.gz -O - | gunzip | tar x \
    && ls \
    && test -e /usr/lib/jvm/jdk1.8.0_162 \
    && ln -s /usr/lib/jvm/jdk1.8.0_162 /usr/lib/jvm/jdk8

# Install JDK7 as an optional JDK
RUN wget http://ftp.osuosl.org/pub/funtoo/distfiles/oracle-java/jdk-7u80-linux-x64.tar.gz -O - | gunzip | tar x \
    && ls \
    && test -e /usr/lib/jvm/jdk1.7.0_80 \
    && ln -s /usr/lib/jvm/jdk1.7.0_80 /usr/lib/jvm/jdk7

# Install JDK9 as an optional JDK
RUN wget -c --header "Cookie: oraclelicense=accept-securebackup-cookie" http://download.oracle.com/otn-pub/java/jdk/9.0.4+11/c2514751926b4512b076cc82f959763f/jdk-9.0.4_linux-x64_bin.tar.gz -O - | gunzip | tar x \
    && ls \
    && test -e /usr/lib/jvm/jdk-9.0.4 \
    && ln -s /usr/lib/jvm/jdk-9.0.4 /usr/lib/jvm/jdk9

WORKDIR /

# Set environment
ENV UNDERLYING_SBT /usr/lib/bin/sbt

# Install packages
RUN apk add --no-cache bash
RUN apk add --no-cache --virtual=build-dependencies wget ca-certificates
RUN apk add --no-cache git
RUN apk add --no-cache openssh
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
RUN $UNDERLYING_SBT about -sbt-create -Dsbt.boot.properties=/sbt.boot

# Remove dependencies
RUN apk del build-dependencies

# Set up and warm up sbt
RUN git clone https://github.com/scalaplatform/warm-sbt && cd warm-sbt && git checkout v0.3.0 && $UNDERLYING_SBT "+run" -Dsbt.boot.properties=/sbt.boot && cd .. && rm -rf warm-sbt
RUN mv /root/.sbt/* /drone/.sbt
RUN rm -rf /root/.sbt

# Set up and test a Scala native project
RUN $UNDERLYING_SBT -Dsbt.boot.properties=/sbt.boot new scala-native/scala-native.g8 --name=seed && cd seed && $UNDERLYING_SBT "run" -Dsbt.boot.properties=/sbt.boot && cd .. && rm -rf seed

# Save some space
RUN rm -rf /tmp/*
RUN mv /root/.coursier/* /drone/.coursier
RUN rm -rf /root/.coursier
