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

nr:
	docker-compose restart node

index-single:
	@:$(if ${${asset}},,$(error Syntax: "make asset=kbh-arkiv/33480 index-single"))
	echo "Indexing ${asset}"
	docker-compose exec node npm run index single ${asset}

index-all:
	echo "Indexing all assets"
	docker-compose exec node npm run index all

.PHONY: index-single index-all reset up
