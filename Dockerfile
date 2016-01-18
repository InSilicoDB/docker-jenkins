FROM jenkins:1.625.3

#jenkins image set user to jenkins to be able to install set back to root
USER root

#install mysql client
RUN apt-get update
RUN apt-get -y install mysql-client

#install some libs for running docker in docker
RUN apt-get -y install \
    apt-transport-https \
    ca-certificates \
    curl \
    lxc

RUN curl "https://s3.amazonaws.com/aws-cli/awscli-bundle.zip" -o "awscli-bundle.zip"
RUN unzip awscli-bundle.zip
RUN ./awscli-bundle/install -i /usr/local/aws -b /usr/local/bin/aws

#install Nextflow
RUN mkdir /home/jenkins
RUN chown -R jenkins:jenkins /home/jenkins
RUN curl -o nextflow -fsSL get.nextflow.io
RUN bash nextflow
#make the nextflow executable from everywhere by moving it into a dir in the $PATH
RUN mv nextflow /usr/local/bin/
RUN chmod a+rx /usr/local/bin/nextflow
#remove laucher file with classpath referencing the root home
RUN rm -r /tmp/nxf-launcher*
# move roots nextflow to jenkins writable dir
RUN mv ~/.nextflow /home/jenkins/.nextflow
RUN chown -R jenkins:jenkins /home/jenkins/.nextflow

ENV NEXTFLOW_HOME /usr/local/bin/nextflow
RUN touch /usr/local/bin/temp.sh
RUN chmod a+rwx /usr/local/bin/temp.sh
RUN head -n 3 /usr/local/bin/jenkins.sh > /usr/local/bin/temp.sh
RUN echo "mv -n /home/jenkins/.nextflow $JENKINS_HOME" >> /usr/local/bin/temp.sh
RUN tail -n $(cat /usr/local/bin/jenkins.sh|wc -l) /usr/local/bin/jenkins.sh >> /usr/local/bin/temp.sh
RUN mv /usr/local/bin/temp.sh /usr/local/bin/jenkins.sh
RUN chmod a+rx /usr/local/bin/jenkins.sh

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
RUN chmod a+x /bin/sbt

# Get SBT to pull base libraries
RUN sbt info

#change uid and gid  of jenkins to the one of the host system
RUN usermod -u 106 jenkins
RUN groupmod -g 112 jenkins
RUN groupadd -g 111 docker
RUN usermod -a -G docker jenkins

USER jenkins
