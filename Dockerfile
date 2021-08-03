FROM alpine:3.14

ENV USERMAP_UID 1000

RUN adduser -D -H 1000

RUN echo "http://dl-cdn.alpinelinux.org/alpine/edge/community" > /etc/apk/repositories
RUN echo "http://dl-cdn.alpinelinux.org/alpine/edge/main" >> /etc/apk/repositories
RUN apk update
RUN apk add chromium
RUN apk add chromium-chromedriver


FROM quay.io/ukhomeofficedigital/docker-aws-cli

RUN pwd
COPY --chown=1000 main.py /import/
RUN ls -la /import
RUN ls -la
RUN mkdir -m777 /python-scripts
COPY --chown=1000 main.py /python-scripts
RUN chmod 777 /import/main.py
RUN chmod 777 /python-scripts/main.py
RUN ls -la /python-scripts

FROM python:3.10.0b4-buster
RUN pip3 install -U selenium
USER 1000
