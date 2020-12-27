LOCAL_CONTAINER=radicale-amd64-local

shell-radicale:
	if [ -z "$$(docker ps -q -f name=$(LOCAL_CONTAINER))" ]; then \
		$(MAKE) start-radicale; \
		sleep 3; \
	fi
	docker exec -it -w /addons/radicale $(LOCAL_CONTAINER) /bin/bash

start-radicale: clean-radicale build-amd64-radicale
	$(MAKE) clean-radicale
	cd test && \
		docker run --rm -it -d \
			-v $$PWD/addons:/addons/ \
			-v $$PWD/data:/data/ \
			-p 5232:5232 \
			--name $(LOCAL_CONTAINER) \
			buhl/radicale-amd64

stop-radicale:
	@if [ -n "$$(docker ps -q -f name=$(LOCAL_CONTAINER))" ]; then \
		docker stop $(LOCAL_CONTAINER); \
	fi

build-amd64-radicale:
	docker run --rm --privileged \
		-v ~/.docker:/root/.docker \
		-v /var/run/docker.sock:/var/run/docker.sock:ro \
		-v $$PWD/radicale:/data \
		homeassistant/amd64-builder \
		--amd64 --target /data --test

build-radicale:
	docker run --rm --privileged \
		-v ~/.docker:/root/.docker \
		-v /var/run/docker.sock:/var/run/docker.sock:ro \
		-v $$PWD/radicale:/data \
		homeassistant/amd64-builder \
		--all --target /data --test

push-radicale:
	docker run --rm --privileged \
		-v ~/.docker:/root/.docker \
		-v /var/run/docker.sock:/var/run/docker.sock:ro \
		-v $$PWD/radicale:/data \
		homeassistant/amd64-builder \
		--all --target /data --docker-hub-check

clean-radicale:
	if [ -n "$$(docker ps -q -f name=$(LOCAL_CONTAINER))" ]; then \
		echo "Container is already running. stopping it"; \
		$(MAKE) stop-radicale; \
	fi
	if [ -n "$(docker ps -aq -f status=exited -f name=<name>)" ]; then \
		docker rm $(LOCAL_CONTAINER); \
	fi;
	sudo rm -fr test/addons/radicale

build-help:
	@docker run --rm homeassistant/amd64-builder --help

.PHONY: build-help build-radicale build-amd64-radicale push-radicale start-radicale stop-radicale shell-radicale
