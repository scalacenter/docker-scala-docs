FROM frolvlad/alpine-glibc:alpine-3.4

# Set environment
ENV JAVA_HOME /usr/lib/jvm/jdk8
ENV PATH $PATH:$JAVA_HOME/bin

RUN apk add --no-cache --virtual=build-dependencies wget ca-certificates \
  && mkdir /usr/lib/jvm

WORKDIR /usr/lib/jvm

# Install JDK8 as the default JDK
RUN wget --no-check-certificate -c --header "Cookie: oraclelicense=accept-securebackup-cookie" http://download.oracle.com/otn-pub/java/jdk/8u151-b12/e758a0de34e24606bca991d704f6dcbf/jdk-8u151-linux-x64.tar.gz -O - | gunzip | tar x \
    && ls \
    && test -e /usr/lib/jvm/jdk1.8.0_151 \
    && ln -s /usr/lib/jvm/jdk1.8.0_151 /usr/lib/jvm/jdk8

# Install JDK7 as an optional JDK
RUN wget http://ftp.osuosl.org/pub/funtoo/distfiles/oracle-java/jdk-7u80-linux-x64.tar.gz -O - | gunzip | tar x \
    && ls \
    && test -e /usr/lib/jvm/jdk1.7.0_80 \
    && ln -s /usr/lib/jvm/jdk1.7.0_80 /usr/lib/jvm/jdk7

# Install JDK9 as an optional JDK
RUN wget -c --header "Cookie: oraclelicense=accept-securebackup-cookie" http://download.oracle.com/otn-pub/java/jdk/9.0.1+11/jdk-9.0.1_linux-x64_bin.tar.gz -O - | gunzip | tar x \
    && ls \
    && test -e /usr/lib/jvm/jdk-9.0.1 \
    && ln -s /usr/lib/jvm/jdk-9.0.1 /usr/lib/jvm/jdk9

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
RUN apk del build-base zlib-dev ruby-dev readline-dev libffi-dev libxml2-dev

# Set up and warm up sbt
RUN git clone https://github.com/scalaplatform/warm-sbt && cd warm-sbt && git checkout v0.3.0 && $UNDERLYING_SBT "+run" -Dsbt.boot.properties=/sbt.boot && cd .. && rm -rf warm-sbt
RUN mv /root/.sbt/* /drone/.sbt
RUN rm -rf /root/.sbt

# Save some space
RUN rm -rf /tmp/*
