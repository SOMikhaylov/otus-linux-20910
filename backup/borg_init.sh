#/bin/bash

export BORG_PASSPHRASE="pass"

borg init -e repokey borg@server:files-etc