# nginx-vhost-proxy-serf

## What it is

This docker image contains a nginx-based dynamic reverse proxy that routes http requests for docker containers based on exposed virtual host information. The image runs a serf agent which must be linked to a serf agent container called serf (use the ctlc/serf image for that).

To register back-end containers with the proxy, run Serf in the back-end containers and link them with the serf agent container. Then, on container startup, join the serf cluster with a role of `xweb` and a tag of `http_vhost`.

See [Nginx](http://nginx.org), [Serf](http://www.serfdom.io) and the [ctlc/serf docker image](https://registry.hub.docker.com/u/ctlc/serf/).

## How it works

The container runs both nginx and a serf agent, controlled be supervisord. Supervisord also runs a join script on startup to make the serf agent join the cluster. Each time a serf node enter or leaves the cluster, the serf agent is registered to run a Python script which regenerates NGinx configuration and reloads it.

