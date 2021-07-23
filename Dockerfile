FROM python:3.8

ENV USERMAP_UID 1000
RUN awk -F: '/\/home/ {printf "%s:%s\n",$1,$3}' /etc/passwd
RUN adduser --no-create-home --disabled-password --uid 1000
# Adding trusting keys to apt for repositories
RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add -
# Adding Google Chrome to the repositories
RUN sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list'
# Updating apt to see and install Google Chrome
RUN apt-get -y update
# Magic happens
RUN apt-get install -y google-chrome-stable
# Installing Unzip
RUN apt-get install -yqq unzip
# Download the Chrome Driver
RUN wget -O /tmp/chromedriver.zip http://chromedriver.storage.googleapis.com/`curl -sS chromedriver.storage.googleapis.com/LATEST_RELEASE `/chromedriver_linux64.zip
# Unzip the Chrome Driver into /usr/local/bin directory
RUN unzip /tmp/chromedriver.zip chromedriver -d /usr/local/bin/
# Set display port as an environment variable
ENV DISPLAY=:99
COPY . /app
WORKDIR /app
RUN pip install --upgrade pip
RUN pip install selenium==3.141.0
FROM quay.io/ukhomeofficedigital/docker-aws-cli

COPY --chown=1000 Move-From-S3.sh /import/
COPY --chown=1000 Move-To-S3.sh /import/ 

RUN ls -la /import

RUN wget https://storage.googleapis.com/kubernetes-release/release/v1.20.0/bin/linux/amd64/kubectl \
  -O /usr/bin/kubectl && chmod 777 /usr/bin/kubectl

RUN chmod +x /import/Move-From-S3.sh
RUN chmod +x /import/Move-To-S3.sh

USER ${USERMAP_UID}

CMD ["python", "./main.py"]
