# Dev environment container
This directory contains the files needed to build a development environment image.

To be built it requires a context with the following structure
```
projects/kbh-billeder
projects/collections-online
scripts/wait-for-it.sh
```

The development image is build with a populated npm node_modules to releave the 
developer from having to run npm install locally.

On the one hand this means the image is quite large (1.5 gig), on the other
hand it skips a time-consuming step.

## Building - automated
Development images are automatically build each time commits are pushed to
the master branch of kbh-billeder. The build is carried out via a google cloud 
build - see kbhbilleder-docker/docker/builder.

## Building - local
You can build a local development image by using kbhbilleder-docker/scripts/build-local-dev-env.sh
Use this approach to test a modification to a package.json prior to pushing.

## Updating lock-files
You can update lock-files by issuing `npm` commands inside the container. After
doing so you should run /usr/local/bin/re-link.sh to rebuild the manual 
`npm link` structure used inside the image.
