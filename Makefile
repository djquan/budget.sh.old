BACKEND_IMAGE := reg.quan.io/dan/budgetsh-backend
FRONTEND_IMAGE := reg.quan.io/dan/budgetsh-frontend
GITHUB_SHA ?= $(shell git rev-parse HEAD)

build-backend:
	@docker build -t ${BACKEND_IMAGE}:latest -t ${BACKEND_IMAGE}:${GITHUB_SHA} -f backend/Dockerfile backend

push-backend:
	@docker push ${BACKEND_IMAGE}:latest
	@docker push ${BACKEND_IMAGE}:${GITHUB_SHA}

build-frontend:
	@docker build -t ${FRONTEND_IMAGE}:latest -t ${FRONTEND_IMAGE}:${GITHUB_SHA} -f frontend/Dockerfile frontend

push-frontend:
	@docker push ${FRONTEND_IMAGE}:latest
	@docker push ${FRONTEND_IMAGE}:${GITHUB_SHA}
