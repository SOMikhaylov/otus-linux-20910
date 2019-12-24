#!/bin/bash

wget https://product-downloads.atlassian.com/software/jira/downloads/atlassian-jira-software-8.6.0-x64.bin 

cat > response.varfile <<EOF
launch.application\$Boolean=true
rmiPort\$Long=8005
app.jiraHome=/var/atlassian/application-data/jira
app.install.service\$Boolean=true
sys.confirmedUpdateInstallationString=false
sys.languageId=en
sys.installationDir=/opt/atlassian/jira
executeLauncherAction\$Boolean=true
httpPort\$Long=8081
portChoice=default
EOF

chmod +x atlassian-jira-software-8.6.0-x64.bin
./atlassian-jira-software-8.6.0-x64.bin -q -varfile response.varfile

cat > /etc/systemd/system/jira.service <<EOF
[Unit] 
Description=Jira unit
After=network.target

[Service] 
Type=forking
User=jira
PIDFile=/opt/atlassian/jira/work/catalina.pid
ExecStart=/opt/atlassian/jira/bin/start-jira.sh
ExecStop=/opt/atlassian/jira/bin/stop-jira.sh

[Install] 
WantedBy=multi-user.target 
EOF

systemctl enable jira.service
reboot