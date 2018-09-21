#
# The commands are:
#   make index-asset 	- bring up all containers

# =============================================================================
# MAIN COMMAND TARGETS
# =============================================================================

up:
	docker-compose up

# Nuke, update and reinstall everything and bring it all up again.
reset:
	docker-compose down -v
	# We have a large image, so it takes a while to come up.
	COMPOSE_HTTP_TIMEOUT=120 docker-compose up -d
	echo "Indexing in the background"
	docker-compose exec -d node npm run index all
	docker-compose logs -f

# Restart node, requires node to be running
nr:
	# In case the container is running and is in debug mode for some reason,
	# disable it.
	@docker-compose exec node touch /var/run/do_debug || true
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

index-all:
	echo "Indexing all assets"
	docker-compose exec node npm run index all

.PHONY: index-single index-all reset up
