The Scala Platform Docker image
========================================

The Scala Platform Docker image is built on top of the Alpine Linux image, which is only a 5MB image, and contains
[Oracle JDK 8](http://www.oracle.com/technetwork/java/javase/downloads/jdk8-downloads-2133151.html)
plus [SBT extras](https://github.com/paulp/sbt-extras),
[git](http://www.scala-sbt.org/download.html), [openssh](https://www.openssh.com/) and
[Jekyll](https://jekyllrb.com/).

It's also bundled with some scripts that are meant to be used by our [Drone
CI](https://platform-ci.scala-lang.org).
