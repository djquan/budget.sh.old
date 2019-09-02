BACKEND_IMAGE := reg.quan.io/dan/budgetsh
GITHUB_SHA ?= $(shell git rev-parse HEAD)

build:
	@docker build -t ${BACKEND_IMAGE}:latest -t ${BACKEND_IMAGE}:${GITHUB_SHA} -f backend/Dockerfile backend

push:
	@docker push ${BACKEND_IMAGE}:latest
	@docker push ${BACKEND_IMAGE}:${GITHUB_SHA}
