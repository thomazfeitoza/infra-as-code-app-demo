.PHONY: deploy-core-infra deploy-backend-app deploy-frontend-app deploy destroy

define terraform_command
	terraform -chdir=$(1) init
	terraform -chdir=$(1) $(2) -auto-approve
endef

deploy-core-infra:
	$(call terraform_command,./components/core-infra,apply)

deploy-backend-app: deploy-core-infra
	$(eval BACKEND_APP_IMAGE := gcr.io/$(shell terraform -chdir=./components/core-infra output --raw gcp_project_id)/backend-app:latest)
	docker build -t $(BACKEND_APP_IMAGE) ./components/applications/backend-app
	docker push $(BACKEND_APP_IMAGE)
	$(call terraform_command,./components/applications/backend-app/infra,apply)

deploy-frontend-app: deploy-backend-app
	$(shell sh ./components/applications/frontend-app/deploy.sh)


deploy: deploy-frontend-app

destroy:
	$(call terraform_command,./components/applications/backend-app/infra,destroy)
	$(call terraform_command,./components/core-infra,destroy)
