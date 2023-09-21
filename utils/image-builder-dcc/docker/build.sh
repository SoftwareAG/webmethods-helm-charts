#!/bin/bash

# Validate latest Software AG Installer version on Empower ...
INSTALLER_VERSION=20230725

curl https://empowersdc.softwareag.com/ccinstallers/SoftwareAGInstaller${INSTALLER_VERSION}-Linux_x86_64.bin --output installer.bin

sed "s/%EMPOWER_PASSWORD%/${EMPOWER_PASSWORD}/g;s/%EMPOWER_USER%/${EMPOWER_USER}/g;" dcc_script_template > dcc_script

docker build . -t dcc:latest