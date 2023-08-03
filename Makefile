TF_DIR := terraform
ANSIBLE_DIR := ansible

# Set AWS profile
AWS_PROFILE := dext
export AWS_PROFILE

.PHONY: init plan apply destroy provision copy_key deploy generate_inventory

init:
	mkdir -p $(TF_DIR)
	cd $(TF_DIR) && terraform init -backend-config="bucket=wordpress-poc-dext-tf-files" -reconfigure

plan:
	cd $(TF_DIR) && terraform plan

apply:
	cd $(TF_DIR) && terraform apply -auto-approve

destroy:
	cd $(TF_DIR) && terraform destroy -auto-approve

#generate_inventory:
#	cd $(TF_DIR) && terraform output -json > ../$(ANSIBLE_DIR)/inventory.json
#	cd $(ANSIBLE_DIR) && jq -r 'to_entries | map("\(.key) ansible_host=\(.value.value)") | join("\n")' inventory.json > ansible_inventory.ini

generate_inventory:
	cd $(TF_DIR) && terraform output -json > ../$(ANSIBLE_DIR)/inventory.json
	cd $(ANSIBLE_DIR) && ./generate_inventory.sh

install_roles:
	cd $(ANSIBLE_DIR) && ./install_roles.sh

provision: init plan apply generate_inventory install_roles
	cd $(ANSIBLE_DIR) && ansible-playbook -i ansible_inventory.ini wordpress.yml

copy_key:
	cp $(TF_DIR)/.terraform/terraform.tfstate $(ANSIBLE_DIR)/wordpress-key.pem

deploy: provision copy_key
	@echo "WordPress and MySQL have been deployed and configured successfully."
