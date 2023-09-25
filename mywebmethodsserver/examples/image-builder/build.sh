#!/bin/bash

# Validate latest Software AG Installer version on Empower ...
INSTALLER_VERSION=20230725

curl https://empowersdc.softwareag.com/ccinstallers/SoftwareAGInstaller${INSTALLER_VERSION}-Linux_x86_64.bin --output installer.bin

sh ./installer.bin create container-image --name $1 --products MwsProgramFiles,monitorUI,optimizeSharedUI,optimizeUI,centralConfiguratorUI --release 10.15 --username $EMPOWER_USER --password $EMPOWER_PASSWORD  --accept-license --admin-password=$2