FROM lsiobase/alpine.nginx:3.8

# set release label if you want
ARG TODOMINI_RELEASE
LABEL maintainer="https://github.com/donovan-murphy/docker-todomini"

RUN \
 echo "**** install packages ****" && \
 apk add --no-cache \
	curl \
	jq && \
 echo "**** install todomini ****" && \
 if [ -z ${TODOMINI_RELEASE+x} ]; then \
	TODOMINI_RELEASE=$(curl -sX GET "https://api.github.com/repos/AppMini/todomini/releases/latest" \
	| awk '/tag_name/{print $4;exit}' FS='[""]'); \
 fi && \
 TODOMINI_FILENAME=$(curl -sX GET "https://api.github.com/repos/AppMini/todomini/releases/latest" \
	| jq -jr '. | .assets[0].name') && \
 mkdir -p \
	/usr/share/webapps/todomini && \
 curl -o \
 /tmp/todomini.zip -L \
	"https://github.com/AppMini/todomini/releases/download/${TODOMINI_RELEASE}/${TODOMINI_FILENAME}" && \
 unzip /tmp/todomini.zip -d /tmp && \
 cp -R /tmp/todomini*/. /usr/share/webapps/todomini/ && \
 echo "**** cleanup ****" && \
 rm -rf \
	/tmp/*

# add local files
COPY root/ /

# ports and volumes
EXPOSE 80
VOLUME /config
