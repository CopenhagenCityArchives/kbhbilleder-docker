#!/bin/bash
touch ./kbh-billeder/google-key.json
npm-link-shared collections-online kbh-billeder && npm-link-shared collections-online-cumulus kbh-billeder
cd ./kbh-billeder && npm install
../wait-for-it.sh elasticsearch:9200 -- npm run start:dev
