FROM node:7.6

RUN apt-get update && apt-get install -y \
    libcairo2-dev \
    libjpeg-dev \
    libpango1.0-dev \
    libgif-dev \
    build-essential \
    g++

WORKDIR /home/node
RUN npm install npm-link-shared -g
COPY ./wait-for-it.sh .
CMD chmod +x ./setup.sh && ./setup.sh

EXPOSE 9001
