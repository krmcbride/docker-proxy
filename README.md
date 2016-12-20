# docker-proxy

An nginx reverse proxy powered by [docker-gen](https://github.com/jwilder/docker-gen) and inspired by [nginx-proxy](https://github.com/jwilder/nginx-proxy) but for less complex usecases. 

This image extends [docker-nginx](https://github.com/krmcbride/docker-nginx) with [forego](https://github.com/ddollar/forego) and `docker-gen` and rewrites/reloads nginx config on certain container lifecycle events.  Specifically this proxy looks for containers with a `PROXY_PATH` environment variable, grouping them by this value into `uptream` blocks and defining a `location` block with a path matching the value of the variable.

The docker-compose.yml file in this repo can be used to test things out.  Running `docker-compose up -d` will start the proxy plus a few simple nginx containers named `foo`, `bar` and `baz`.  Each has a `PROXY_PATH` environment variable set to `foo:/`, `bar` and `baz` respectively.  If the value of the `PROXY_PATH` variable does not include a `:`, it is used as both the upstream name and location path (wrapped with `/`).  Otherwise, the first part before the `:` is used as the upstream name
and the second part after the `:` is used as the location path (as-is, without being wrapped with `/`).

The generated server config initially looks like:

```
upstream foo {
  server 172.18.0.3:80;
}
upstream bar {
  server 172.18.0.4:80;
}
upstream baz {
  server 172.18.0.5:80;
}
server {
  location / {
    proxy_pass http://foo/;
  }
  location /bar/ {
    proxy_pass http://bar/;
  }
  location /baz/ {
    proxy_pass http://baz/;
  }
}
```

If we scale the number of containers with `docker-compose scale foo=2 bar=3 baz=4` the resulting config looks like:

```
upstream foo {
  server 172.18.0.5:80;
  server 172.18.0.3:80;
}
upstream bar {
  server 172.18.0.7:80;
  server 172.18.0.6:80;
  server 172.18.0.4:80;
}
upstream baz {
  server 172.18.0.11:80;
  server 172.18.0.10:80;
  server 172.18.0.9:80;
  server 172.18.0.8:80;
}
server {
  location / {
    proxy_pass http://foo/;
  }
  location /bar/ {
    proxy_pass http://bar/;
  }
  location /baz/ {
    proxy_pass http://baz/;
  }
}
```

Requests to `http://localhost`, `http://localhost/bar` and `http://localhost/baz` will be load balanced across each upstream server.

If the upstream container exposes one port, that port will be used in server directives, otherwise a default of port 80 is used. The upstream container can use an environment variable of `PROXY_PORT` to override the default.

