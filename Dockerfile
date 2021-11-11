FROM ubuntu:16.04

# Install dependencies
RUN apt-get update --yes && apt-get upgrade --yes

RUN apt-get --yes install curl gnupg

RUN curl -sL https://deb.nodesource.com/setup_6.x  | bash -
RUN apt-get --yes install nodejs
RUN node --version

RUN DEBIAN_FRONTEND="noninteractive" apt-get install --yes tzdata

RUN apt-get --yes install git libcairo2-dev libjpeg8-dev libpango1.0-dev libgif-dev libpng-dev build-essential g++ ffmpeg redis-server

# Non-privileged user
RUN useradd -m audiogram
USER audiogram
WORKDIR /home/audiogram

# Clone repo
# RUN git clone https://github.com/nypublicradio/audiogram.git
# WORKDIR /home/audiogram/audiogram

ADD . /home/audiogram
WORKDIR /home/audiogram

RUN mkdir -p editor/js

# Install dependencies
RUN npm install

USER root
RUN npm install -g browserify@13.0.0
RUN browserify client/index.js > editor/js/bundle.js
