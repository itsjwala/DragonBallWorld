
---

### Terraform 

provisioning servers

* Encryption/Decryption secrets using ansible-vault


```sh
# decrypt 
make unseal

# encrypt 
make seal 
```

what is encrypted?

`secrets.tfvars` contains which has necessary tokens which is ecrypted using `ansible-vault`

`terraform.tfstate` statefile for terraform which keeps track of all resources in cloud

* provision 

```sh

# terraform init
make init

# terraform plan
make plan

# terraform apply
make apply

```





### Ansible

Installation of packages and making it ready for cluster


* setup local python environment

```sh
virtualenv venv
source venv
pip install -r requirements.txt
```

my `.ssh/config` contains config so I can ssh into server


```sh

Host chini
    hostname SOME_IP_1
    user jigar.w

Host goku
    hostname SOME_IP_2
    user itsjwala

Host gohan
    hostname SOME_IP_3
    user itsjwala

```

#### Note: 


>Initially user will be `root` / `pi` (for raspberrypi) / `ubuntu` depending on how the server is being provisioned at first, use same user in `.ssh/config` or ansible `hosts` vars, YMMV !

adding servers in `hosts` file

```ini
[DragonBallWorld]
goku
gohan

[DragonBallWorld:vars]
username=itsjwala
github_ssh_key_url=https://github.com/itsjwala.keys

[Namek]
chini
```

* run ansible common role

check `roles/common` to check what it does.

```sh
ansible-playbook playbooks/any.yml --inventory hosts --limit gohan --tag role-common
```


* tailscale setup

generate auth token from tailscale and add under `vars` 
```sh
ansible-playbook playbooks/any.yml --inventory hosts --limit gohan --tag role-tailscale_setup --ask-vault-pass
```
