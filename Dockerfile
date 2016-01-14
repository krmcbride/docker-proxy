FROM krmcbride/nginx:1.9
MAINTAINER Kevin McBride <krmcbride.io@gmail.com>

# Install Forego
RUN wget -P /usr/local/bin https://godist.herokuapp.com/projects/ddollar/forego/releases/current/linux-amd64/forego \
 && chmod u+x /usr/local/bin/forego

ENV DOCKER_GEN_VERSION 0.4.0

RUN wget https://github.com/jwilder/docker-gen/releases/download/$DOCKER_GEN_VERSION/docker-gen-linux-amd64-$DOCKER_GEN_VERSION.tar.gz \
 && tar -C /usr/local/bin -xvzf docker-gen-linux-amd64-$DOCKER_GEN_VERSION.tar.gz \
 && rm docker-gen-linux-amd64-$DOCKER_GEN_VERSION.tar.gz

RUN mkdir /etc/nginx/sites-enabled

COPY Procfile /Procfile
COPY nginx.tmpl /nginx.tmpl
COPY nginx.conf /etc/nginx/nginx.conf
COPY mime.types /etc/nginx/mime.types

ENV DOCKER_HOST unix:///tmp/docker.sock

CMD ["/usr/local/bin/forego", "start", "-r", "-f", "/Procfile"]
