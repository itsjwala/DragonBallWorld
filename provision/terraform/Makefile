.PHONY: init plan apply lint

unseal:
	- ansible-vault decrypt secrets.tfvars terraform.tfstate 

seal:
	- ansible-vault encrypt secrets.tfvars terraform.tfstate

plan: unseal
	- terraform14 plan -var-file=secrets.tfvars

init: unseal
	- terraform14 init -var-file=secrets.tfvars 

apply: unseal
	- terraform14 apply -var-file=secrets.tfvars --auto-approve

lint:
	- terraform14 validate && terraform14 fmt -recursive
