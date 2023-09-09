#!/bin/bash
export VAULT_ADDR=http://vaultserver:8200
wget https://releases.hashicorp.com/vault-ssh-helper/0.2.1/vault-ssh-helper_0.2.1_linux_amd64.zip
unzip vault-ssh-helper_0.2.1_linux_amd64.zip
mv vault-ssh-helper /usr/local/bin
rm vault-ssh-helper_0.2.1_linux_amd64.zip