# docker-proxy

An nginx reverse proxy powered by [docker-gen](https://github.com/jwilder/docker-gen) and inspired by [nginx-proxy](https://github.com/jwilder/nginx-proxy) but for less complex usecases. 

This image extends [docker-nginx](https://github.com/krmcbride/docker-nginx) with [forego](https://github.com/ddollar/forego) and `docker-gen` and rewrites/reloads nginx config on certain container lifecycle events.  Specifically this proxy looks for containers with a `PROXY_PATH` environment variable, grouping them by this value into `uptream` blocks and defining a `location` block with a path matching the value of the variable.

The docker-compose.yml file in this repo can be used to test things out.  Running `docker-compose up -d` will start the proxy plus two simple nginx containers named `foo` and `bar`.  Each has a `PROXY_PATH` environment variable set to `foo` and `bar` respectively.  The initial nginx server config generated in `docker-proxy` looks like:

```
upstream foo {
  server 172.18.0.3:80;
}
upstream bar {
  server 172.18.0.4:80;
}
server {
  location /foo/ {
    proxy_pass http://foo/;
  }
  location /bar/ {
    proxy_pass http://bar/;
  }
}
```

If we scale to 3 `foo` containers and 4 `bar` containers with `docker-compose scale foo=3` and `docker-compose scale bar=4` the resulting config looks like:

```
upstream foo {
  server 172.18.0.6:80;
  server 172.18.0.5:80;
  server 172.18.0.3:80;
}
upstream bar {
  server 172.18.0.9:80;
  server 172.18.0.8:80;
  server 172.18.0.7:80;
  server 172.18.0.4:80;
}
server {
  location /foo/ {
    proxy_pass http://foo/;
  }
  location /bar/ {
    proxy_pass http://bar/;
  }
}
```

Requests to `http://localhost/foo` and `http://localhost/bar` will be load balanced across each upstream server.

If the upstream container exposes one port, that port will be used in server directives, otherwise a default of port 80 is used. The upstream container can use an environment variable of `PROXY_PORT` to override the default.

