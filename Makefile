#
# The commands are:
#   make index-asset 	- bring up all containers

# =============================================================================
# MAIN COMMAND TARGETS
# =============================================================================

# Start the setup - give us an extra long timeout.
up:
	COMPOSE_HTTP_TIMEOUT=300 docker-compose up -d
	docker-compose logs -f --tail=50

down:
	docker-compose down

# Nuke, update and reinstall everything and bring it all up again.
reset:
	docker-compose down -v
	# We have a large image, so it takes a while to come up.
	COMPOSE_HTTP_TIMEOUT=300 docker-compose up -d
	echo "Indexing in the background"
	docker-compose exec -d node npm run index all
	docker-compose logs -f --tail=50

# Restart node, requires node to be running
nr:
    # In case the container is running and is in debug mode for some reason,
    # disable it.
	@docker-compose exec node rm -f /var/run/do_debug || true
	docker-compose restart node

# Switch node into debug mode.
debug:
	@docker-compose exec node touch /var/run/do_debug
	@echo "Starting node with debugging enabled"
	docker-compose restart node
	@docker-compose exec node bash -c 'echo "Press any key to stop debugging"; read; rm /var/run/do_debug; echo "Restarting node debuggging disabled"'
	docker-compose restart node

# Index a single asset.
index-single:
	./scripts/index-single-asset.sh

# Make the production elasticsearch available via localhost:9300.
forward-es-prod:
	@scripts/es-connect-env.sh production

# Make the beat elasticsearch available via localhost:9300.
forward-es-beta:
	@scripts/es-connect-env.sh beta

# Start tailing local docker logs.
logs:
	docker-compose logs -f --tail=50

# Do a full re-index of the local environment.
index-all:
	echo "Indexing all assets"
	docker-compose exec node npm run index all

# Build a local cloud builder image.
# can be used in consert with run-builder to test a change to the builder
# locally.
build-builder:
	./scripts/build-builder.sh

# Run a local cloud builder build using our local kbhbilleder-docker as context.
# Use this target for testing changes made to the parts of kbhbilleder-docker
# the dev-env builder uses.
# Can also be used for building local dev-env images after changes to eg.
# lock files.
build-dev-env-local:
	./scripts/run-builder-local.sh

# Run a local cloud builder using clean checkouts of all repos.
# Use this to test a locally build builder against a clean base.
build-dev-env:
	./scripts/run-builder.sh

# Use this if you've run npm install/update inside the containers.
relink:
	docker-compose exec node /usr/local/bin/re-link.sh

# Lauch a local web-server for browsing documentation that requires a webserver.
docs:
	@echo "Launching webserver."
	@echo "Direct: "
	@echo " - http://localhost:8099/docs/map-integration/contract/search.html"
	@echo " - http://localhost:8099/docs/map-integration/contract/asset.html"
	@echo "Dory: "
	@echo " - http://docs.kbhbilleder.docker/docs/map-integration/contract/search.html"
	@echo " - http://docs.kbhbilleder.docker/docs/map-integration/contract/asset.html"
	@echo "Press ctrl-c to quit"
	docker run --rm -p 8099:80 -e VIRTUAL_HOST=docs.kbhbilleder.docker -v "${CURDIR}/projects/kbh-billeder:/usr/share/nginx/html:ro" nginx:stable

# Triggger a circle-ci build of the master-branch of kbh-billeder which in
# turn will do a deploy to beta.kbhbilleder.dk
circleci-build:
	./scripts/trigger-circle-ci-build.sh

# TODO
# - Trigger a cloud build of the dev environment - for eg. when you push to collection-online
# - Something that ensures kubectl has the correct context.
