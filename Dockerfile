FROM jenkins:1.625.3

#jenkins image set user to jenkins to be able to install set back to root
USER root

# Update for new versions
ENV SCALA_VERSION 2.11.7
ENV SBT_VERSION 0.13.8

# Scala
RUN curl -O -L http://downloads.typesafe.com/scala/${SCALA_VERSION}/scala-${SCALA_VERSION}.tgz
RUN tar xzvf scala-${SCALA_VERSION}.tgz
RUN rm scala-${SCALA_VERSION}.tgz

ENV SCALA_HOME /scala-${SCALA_VERSION}
ENV PATH ${SCALA_HOME}/bin:$PATH

# SBT
RUN curl -O -L https://repo.typesafe.com/typesafe/ivy-releases/org.scala-sbt/sbt-launch/${SBT_VERSION}/sbt-launch.jar
RUN mv sbt-launch.jar /bin/sbt-launch.jar
COPY sbt /bin/sbt
RUN chmod u+x /bin/sbt

# Get SBT to pull base libraries
RUN sbt info

#change uid and gid of jenkins to the one of the host system
RUN usermod -u 106 jenkins
RUN groupmod -g 112 jenkins

COPY start.sh /usr/local/bin/start.sh
ENTRYPOINT ["/bin/tini", "--", "/usr/local/bin/start.sh"]
