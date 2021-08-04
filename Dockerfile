FROM python:3.10.0b4-buster

ENV AWS_CLI_VERSION 1.16.207

RUN apk --no-cache update && \
    apk --no-cache add python py-pip py-setuptools ca-certificates groff less && \
    pip --no-cache-dir install awscli==${AWS_CLI_VERSION} && \
    rm -rf /var/cache/apk/*
RUN mkdir /data && chown 1000 /data

ENV USERMAP_UID 1000

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

RUN ls -la
RUN ls -la /import
RUN ls -la /python-scripts
RUN pip3 install -U selenium
USER 1000
