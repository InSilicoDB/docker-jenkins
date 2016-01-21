# docker-jenkins

Container containing deps to be able to have CI environment where all are projects can be tested.


## Usage

The container should be started like this.

```
docker run -d -p 8080:8080 -p 50000:50000 -v /var/jenkins:/var/jenkins_home -v /var/run/docker.sock:/var/run/docker.sock -v $(which docker):/usr/bin/docker --name jenkins-insilico --link mysql --link redis insilicodb/docker-scala
```

Where `--link mysql --link redis` are just two standard containers that are linked, to provide a mysql db and a redis key-value store.
On the host docker is installed and also made available in the container with: `-v /var/run/docker.sock:/var/run/docker.sock -v $(which docker):/usr/bin/docker`. It is also important to have the same path mounted for `/var/jenkins` on the host as in the container. Because when jenkins starts a container. it's actually started from the host. So custom paths in the container are not mountable.
