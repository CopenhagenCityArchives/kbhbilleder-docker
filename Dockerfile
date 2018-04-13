FROM node:7.6

RUN apt-get update && apt-get install -y \
    libcairo2-dev \
    libjpeg-dev \
    libpango1.0-dev \
    libgif-dev \
    build-essential \
    g++ \
    libnotify-bin

ENV NODE_ENV=development
ENV NPM_CONFIG_LOGLEVEL warn

WORKDIR /home/node/kbh-billeder

COPY kbh-billeder/package*.json ./

RUN npm install --silent --progress=false

WORKDIR /home/node/collections-online
COPY ./collections-online/package.json .
RUN npm link

WORKDIR /home/node/collections-online-cumulus
COPY ./collections-online-cumulus/package.json .
RUN npm link

COPY . .

WORKDIR /home/node/kbh-billeder/node_modules
RUN rm -rf collections-online && rm -rf collections-online-cumulus
run ln -s /usr/local/lib/node_modules/collections-online collections-online && ln -s /usr/local/lib/node_modules/collections-online-cumulus collections-online-cumulus

WORKDIR /home/node/collections-online-cumulus/node_modules
RUN rm -rf collections-online
run ln -s /usr/local/lib/node_modules/collections-online collections-online

WORKDIR /home/node/collections-online/node_modules
RUN rm -rf collections-online
run ln -s /usr/local/lib/node_modules/collections-online collections-online

WORKDIR /home/node/kbh-billeder

CMD ../wait-for-it.sh elasticsearch:9200 -- bash -c '../index.sh & npm run start:dev'

EXPOSE 9001
