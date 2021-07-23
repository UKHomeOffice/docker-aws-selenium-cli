FROM alpine:3.14

ENV USERMAP_UID 1000

RUN adduser -D -H 1000 

RUN echo "http://dl-cdn.alpinelinux.org/alpine/edge/community" > /etc/apk/repositories
RUN echo "http://dl-cdn.alpinelinux.org/alpine/edge/main" >> /etc/apk/repositories
RUN apk update
RUN apk add chromium
RUN apk add chromium-chromedriver
RUN apk add python3
RUN apk add py3-pip
RUN pip3 install -U selenium

FROM quay.io/ukhomeofficedigital/docker-aws-cli

COPY --chown=1000 Move-From-S3.sh /import/
COPY --chown=1000 Move-To-S3.sh /import/ 




RUN chmod +x /import/Move-From-S3.sh
RUN chmod +x /import/Move-To-S3.sh

USER 1000

