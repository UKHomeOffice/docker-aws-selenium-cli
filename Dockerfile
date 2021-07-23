FROM alpine:3.14

ENV USERMAP_UID 1000

RUN adduser -D -H 1000 

RUN echo "http://dl-cdn.alpinelinux.org/alpine/edge/community" > /etc/apk/repositories
RUN echo "http://dl-cdn.alpinelinux.org/alpine/edge/main" >> /etc/apk/repositories
RUN apk update
RUN apk add chromium
RUN apk add chromium-chromedriver
RUN apk add python3
RUN pip3 install -U selenium

FROM quay.io/ukhomeofficedigital/docker-aws-cli

COPY --chown=1000 Move-From-S3.sh /import/
COPY --chown=1000 Move-To-S3.sh /import/ 

RUN ls -la /import

RUN wget https://storage.googleapis.com/kubernetes-release/release/v1.20.0/bin/linux/amd64/kubectl \
  -O /usr/bin/kubectl && chmod 777 /usr/bin/kubectl

RUN apk upgrade --no-cache
RUN apk add --no-cache bash openssl gettext


RUN chmod +x /import/Move-From-S3.sh
RUN chmod +x /import/Move-To-S3.sh

USER ${USERMAP_UID}

