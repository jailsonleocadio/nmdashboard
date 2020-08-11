# nmdashboard

To run:

```sh
$ cd nmdashboard/dashboard
$ docker build -t nm-dashboard .
$ docker network create dash-net
$ cd ../
$ docker build . -t shinyproxy
$ docker run -d -v /var/run/docker.sock:/var/run/docker.sock --net dash-net -p 3838:3838 shinyproxy
```
