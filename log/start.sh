#/bin/bash

vagrant up &&
ansible-playbook nginx.yml -v &&
ansible-playbook rsyslog.yml -v 
# ansible-playbook elk.yml -v 
# ansible-playbook filebeat.yml