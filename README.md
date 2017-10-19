The Scala Platform Docker image
========================================

The Scala Platform Docker image is built on top of the Alpine Linux image, which
is only a 5MB image, and contains JDKs, [SBT
extras](https://github.com/paulp/sbt-extras),
[git](http://www.scala-sbt.org/download.html),
[openssh](https://www.openssh.com/) and [Jekyll](https://jekyllrb.com/).

It's also bundled with some scripts that are meant to be used by [Scala
Platform's Drone CI](https://platform-ci.scala-lang.org) and
[`sbt-platform`](https://github.com/scalacenter/platform).

## Supported JDKs

- JDK7 at `/usr/share/jvm/jdk7`.
- JDK8 at `/usr/share/jvm/jdk8` (**default**).
- JDK9 at `/usr/share/jvm/jdk9`.
