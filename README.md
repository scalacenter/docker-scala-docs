The Scala Platform Docker image
========================================

The Scala Platform Docker image is built on top of the Alpine Linux image, which
is only a 5MB image, and contains [Oracle JDK
8](http://www.oracle.com/technetwork/java/javase/downloads/jdk8-downloads-2133151.html)
plus [SBT extras](https://github.com/paulp/sbt-extras),
[git](http://www.scala-sbt.org/download.html),
[openssh](https://www.openssh.com/) and [Jekyll](https://jekyllrb.com/).

This image also has support for the JDK7, which you can find installed in
`/usr/share/jvm/jdk7`. JDK8 is installed in `/usr/share/jvm/jdk8` and is the
default one.

It's also bundled with some scripts that are meant to be used by [Scala
Platform's Drone CI](https://platform-ci.scala-lang.org) and
[`sbt-platform`](https://github.com/scalacenter/platform).
