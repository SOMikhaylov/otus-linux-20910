#!/bin/bash

vagrant up &&
ansible-playbook firewalld.yml   -v &&
ansible-playbook ipa-server.yml  -v &&
ansible-playbook ipa-client.yml  -v &&
ansible-playbook ipa-create-user.yml -v
