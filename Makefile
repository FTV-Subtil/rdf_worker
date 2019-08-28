ENVFILE?=.env
ifeq ($(shell test -e $(ENVFILE) && echo -n yes),yes)
	include ${ENVFILE}
	export
endif

DOCKER_REGISTRY?=
DOCKER_IMG_NAME?=ftvsubtil/rdf_worker
ifneq ($(DOCKER_REGISTRY), ) 
	DOCKER_IMG_NAME := /${DOCKER_IMG_NAME}
endif
VERSION=$(shell cargo metadata --no-deps --format-version 1 | jq '.packages[0].version' )

build:
	@cargo build

ci-code-format:
	@cargo fmt --all -- --check

ci-code-coverage:
	@cargo tarpaulin

ci-lint:
	@cargo clippy

ci-tests:
	@cargo test

docker-build:
	@docker build -t ${DOCKER_REGISTRY}${DOCKER_IMG_NAME}:${VERSION} .

docker-clean:
	@docker rmi ${DOCKER_REGISTRY}${DOCKER_IMG_NAME}:${VERSION}

docker-push-registry:
	@docker push ${DOCKER_REGISTRY}${DOCKER_IMG_NAME}:${VERSION}

run:
	@cargo run rs_rdf_worker

version:
	@echo ${VERSION}