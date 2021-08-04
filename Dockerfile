FROM alpine:3.14
FROM quay.io/ukhomeofficedigital/docker-aws-cli
FROM python:3.10.0b4-buster
ENV USERMAP_UID 1000
USER root
RUN adduser -D -H 1000

RUN echo "http://dl-cdn.alpinelinux.org/alpine/edge/community" > /etc/apk/repositories
RUN echo "http://dl-cdn.alpinelinux.org/alpine/edge/main" >> /etc/apk/repositories
RUN apk update
RUN apk add chromium
RUN apk add chromium-chromedriver
WORKDIR /

RUN pwd
COPY --chown=1000 main.py /import
RUN ls -la /import
RUN ls -la
RUN mkdir -m777 /python-scripts
COPY --chown=1000 main.py /python-scripts

RUN ls -la /python-scripts
RUN ls -la

RUN ls -la
RUN ls -la /python-scripts
RUN ls -la /import
FROM python:3.10.0b4-buster
RUN ls -la
RUN ls -la /import
RUN ls -la /python-scripts
RUN pip3 install -U selenium
USER 1000
