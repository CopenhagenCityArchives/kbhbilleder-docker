FROM node:7.6

RUN apt-get update && apt-get install -y \
    libcairo2-dev \
    libjpeg-dev \
    libpango1.0-dev \
    libgif-dev \
    build-essential \
    g++

WORKDIR /home/node/kbh-billeder
COPY wait-for-it.sh /home/node/
CMD npm install && npm run gulp
CMD npm link ../collections-online && npm link ../collections-online-cumulus
CMD /home/node/wait-for-it.sh elasticsearch:9200 -- npm run start:nodemon && npm run index all

EXPOSE 9001

