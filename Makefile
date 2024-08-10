GREEN  := $(shell tput -Txterm setaf 2)
YELLOW := $(shell tput -Txterm setaf 3)
WHITE  := $(shell tput -Txterm setaf 7)
RESET  := $(shell tput -Txterm sgr0)
.DEFAULT_GOAL := help

ping: ## ping inventory
	@ansible all -i inventory.py -m ping

boot: ## boot0up over wol
	@wakeonlan --ip ${HOMELAB_BROADCAST_ADDRESS} ${HOMELAB_MAC_ADDRESS}

ssh: ## ssh into host
	@ssh "${HOMELAB_USER}@${HOMELAB_IP}"

deploy: ## deploy playbook
	@ansible-playbook -i inventory.py playbook.yml --extra-vars "state=present"

teardown: ## teardown playbook
	@ansible-playbook -i inventory.py playbook.yml --extra-vars "state=absent"

help: ## show this help.
	@echo 'Usage:'
	@echo '  ${YELLOW}make${RESET} ${GREEN}<target>${RESET}'
	@echo ''
	@echo 'Targets:'
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "  ${YELLOW}%-24s${GREEN}%s${RESET}\n", $$1, $$2}' $(MAKEFILE_LIST)
