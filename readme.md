# Ansible Test

- This will be created on /tmp/test-envars view on the script test.yml


## How to Debug
- ansible-vault view group_vars/local/vault.yml -> To view the config
- find $(pwd) -type f -name "*.yml" -> Find yml file
- ansible-playbook -i inventory/hosts playbooks/test.yml --ask-vault-pass -vvv -> To running the test
- 


## Create the ansible
- ansible-vault create group_vars/local/vault.yml
