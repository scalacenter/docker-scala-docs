FROM joshdev/alpine-oraclejdk8:8u102

# Set environment
ENV UNDERLYING_SBT /usr/lib/bin/sbt

# Add all scripts in image
COPY bin /usr/local/bin
COPY sbt.boot /sbt.boot

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

RUN export PATH="/root/.rbenv/bin:$PATH"
RUN gem update --system
RUN gem install sass
RUN gem install jekyll

RUN mkdir /usr/lib/bin
RUN curl -s https://raw.githubusercontent.com/paulp/sbt-extras/master/sbt > /usr/lib/bin/sbt
RUN chmod 0755 /usr/lib/bin/sbt

# Copy our custom sbt to the default location, replace previous
RUN mv /usr/local/bin/sbt /usr/bin/sbt
RUN $UNDERLYING_SBT about -sbt-create -Dsbt.boot.properties=/sbt.boot

# Set up and warm sbt
RUN mkdir /root/scala-212
RUN mkdir /root/scala-212/project
RUN echo 'sbt.version = 0.13.13' > /root/scala-212/project/build.properties
RUN echo 'scalaVersion := "2.12.1"' > /root/scala-212/build.sbt
RUN mkdir -p /root/scala-212/src/main/scala
RUN echo 'object Main { def main(args: Array[String]): Unit = println("Hello, World!") }' > /root/scala-212/src/main/scala/Main.scala
RUN cd /root/scala-212; $UNDERLYING_SBT run -Dsbt.boot.properties=/sbt.boot

RUN mkdir /root/scala-211
RUN mkdir /root/scala-211/project
RUN echo 'sbt.version = 0.13.13' > /root/scala-211/project/build.properties
RUN echo 'scalaVersion := "2.11.8"' > /root/scala-211/build.sbt
RUN mkdir -p /root/scala-211/src/main/scala
RUN echo 'object Main { def main(args: Array[String]): Unit = println("Hello, World!") }' > /root/scala-211/src/main/scala/Main.scala
RUN cd /root/scala-211; $UNDERLYING_SBT run -Dsbt.boot.properties=/sbt.boot

RUN mkdir /root/scala-210
RUN mkdir /root/scala-210/project
RUN echo 'sbt.version = 0.13.13' > /root/scala-210/project/build.properties
RUN echo 'scalaVersion := "2.10.6"' > /root/scala-210/build.sbt
RUN mkdir -p /root/scala-210/src/main/scala
RUN echo 'object Main { def main(args: Array[String]): Unit = println("Hello, World!") }' > /root/scala-210/src/main/scala/Main.scala
RUN cd /root/scala-210; $UNDERLYING_SBT run -Dsbt.boot.properties=/sbt.boot

RUN mkdir /root/dotty
RUN mkdir /root/dotty/project
RUN echo 'sbt.version = 0.13.13' > /root/dotty/project/build.properties
RUN echo 'addSbtPlugin("com.felixmulder" % "sbt-dotty" % "0.1.9")' > /root/dotty/project/plugins.sbt
RUN echo 'enablePlugins(DottyPlugin)' > /root/dotty/build.sbt
RUN mkdir -p /root/dotty/src/main/scala
RUN echo 'object Main { def main(args: Array[String]): Unit = println("Hello, World!") }' > /root/dotty/src/main/scala/Main.scala
RUN cd /root/dotty; $UNDERLYING_SBT run -Dsbt.boot.properties=/sbt.boot

RUN git clone https://github.com/olafurpg/warm-sbt
RUN cd warm-sbt && git checkout v0.1.0 && $UNDERLYING_SBT "++run" -Dsbt.boot.properties=/sbt.boot && cd .. && rm -rf warm-sbt
RUN mv /root/.sbt/* /drone/.sbt

# Remove dependencies
RUN apk del build-dependencies
RUN apk del build-base zlib-dev ruby-dev readline-dev libffi-dev libxml2-dev
RUN rm -rf /tmp/*
