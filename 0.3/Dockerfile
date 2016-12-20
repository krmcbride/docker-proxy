FROM krmcbride/nginx:1.11
MAINTAINER Kevin McBride <krmcbride.io@gmail.com>

ENV FOREGO_VERSION 0.16.1
ADD https://github.com/jwilder/forego/releases/download/v${FOREGO_VERSION}/forego /usr/local/bin/forego
RUN chmod u+x /usr/local/bin/forego

ENV DOCKER_GEN_VERSION 0.7.3
RUN wget https://github.com/jwilder/docker-gen/releases/download/$DOCKER_GEN_VERSION/docker-gen-linux-amd64-$DOCKER_GEN_VERSION.tar.gz \
    && tar -C /usr/local/bin -xvzf docker-gen-linux-amd64-$DOCKER_GEN_VERSION.tar.gz \
    && rm docker-gen-linux-amd64-$DOCKER_GEN_VERSION.tar.gz

COPY Procfile /Procfile
COPY nginx.tmpl /nginx.tmpl

ENV DOCKER_HOST unix:///tmp/docker.sock

CMD ["/usr/local/bin/forego", "start", "-r", "-f", "/Procfile"]
