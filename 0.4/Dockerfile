FROM krmcbride/nginx:1.13
MAINTAINER Kevin McBride <krmcbride.io@gmail.com>

ENV FOREGO_VERSION 0.16.1
ENV DOCKER_GEN_VERSION 0.7.3

ADD \
    https://github.com/jwilder/forego/releases/download/v${FOREGO_VERSION}/forego \
    https://github.com/jwilder/docker-gen/releases/download/$DOCKER_GEN_VERSION/docker-gen-linux-amd64-$DOCKER_GEN_VERSION.tar.gz \
    /tmp/

RUN mv /tmp/forego /usr/local/bin/ \
    && chmod u+x /usr/local/bin/forego \
    && tar -C /usr/local/bin -xvzf /tmp/docker-gen-linux-amd64-$DOCKER_GEN_VERSION.tar.gz \
    && rm /tmp/docker-gen-linux-amd64-$DOCKER_GEN_VERSION.tar.gz

COPY Procfile /Procfile
COPY nginx.tmpl /nginx.tmpl

ENV DOCKER_HOST unix:///tmp/docker.sock

CMD ["/usr/local/bin/forego", "start", "-r", "-f", "/Procfile"]
