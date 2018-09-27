The Scala Platform Docker image
========================================

Depend on it with `scalacenter/scala-docs:1.5`.

The Scala Platform Docker image is built on top of the Alpine Linux image, which
is only a 5MB image, and contains JDKs, [SBT
extras](https://github.com/paulp/sbt-extras),
[git](http://www.scala-sbt.org/download.html),
[openssh](https://www.openssh.com/) and [Jekyll](https://jekyllrb.com/).

It's also bundled with some scripts that are meant to be used by [Scala
Platform's Drone CI](https://platform-ci.scala-lang.org) and
[`sbt-platform`](https://github.com/scalacenter/platform).

## Supported JDKs

- JDK8 at `/usr/lib/jvm/jdk8/bin` (**default**).
- JDK10 at `/usr/lib/jvm/jdk10/bin`.
- JDK11 at `/usr/lib/jvm/jdk11/bin`.

If you want to run your program with any of these JDKs, redefine `$JAVA_HOME`
and add the new home to the beginning of the `$PATH` (the default jdk 8 will be
at the end of it).

For example, the following statements switch to JDK 11 (remember that
environment variables are only temporary):

```
$ export JAVA_HOME="/usr/lib/jvm/jdk8/bin"
$ export PATH="$JAVA_HOME:$PATH"
$ java -version
java version "11" 2018-09-25
Java(TM) SE Runtime Environment 18.9 (build 11+28)
Java HotSpot(TM) 64-Bit Server VM 18.9 (build 11+28, mixed mode)
```
