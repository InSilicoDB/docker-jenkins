# docker-scala
Scala container to build and test the Pipelines-microservice in the CI Jenkins


```
ocker run -d -p 8080:8080 -p 50000:50000 -v /var/jenkins:/var/jenkins_home -v /var/run/docker.sock:/var/run/docker.sock -v $(which docker):/usr/bin/docker --name jenkins-insilico --link mysql --link redis insilicodb/docker-scala
```
