FROM node:7.6-alpine

RUN apk add --no-cache \
    build-base \
    g++ \
    cairo-dev \
    jpeg-dev \
    pango-dev \
    giflib-dev \
    libc6-compat \
    git \
    bash

ENV NODE_ENV=development
ENV NPM_CONFIG_LOGLEVEL warn

WORKDIR /home/node/kbh-billeder

COPY kbh-billeder/package*.json ./

RUN npm install --progress=false

WORKDIR /home/node/collections-online
COPY ./collections-online/package*.json ./
RUN npm link

WORKDIR /home/node/collections-online-cumulus
COPY ./collections-online-cumulus/package*.json ./
RUN npm link

COPY . .

WORKDIR /home/node/kbh-billeder/node_modules
RUN rm -rf collections-online && rm -rf collections-online-cumulus && \
    ln -s /usr/local/lib/node_modules/collections-online collections-online && ln -s /usr/local/lib/node_modules/collections-online-cumulus collections-online-cumulus

WORKDIR /home/node/collections-online-cumulus/node_modules
RUN rm -rf collections-online && ln -s /usr/local/lib/node_modules/collections-online collections-online

WORKDIR /home/node/collections-online/node_modules
RUN rm -rf collections-online && ln -s /usr/local/lib/node_modules/collections-online collections-online

WORKDIR /home/node/kbh-billeder

CMD ../wait-for-it.sh elasticsearch:9200 -- npm run index all & npm run start:dev

EXPOSE 9001
