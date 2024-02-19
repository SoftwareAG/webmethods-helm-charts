# Use base image ...
ARG BASE_IMAGE
FROM ${BASE_IMAGE}

# Following parameters are needed ...
#   Empower credentials ...
ARG EMPOWER_USERNAME
ARG EMPOWER_PASSWORD
ARG INSTALLER_VERSION
ARG RELEASE
ARG ADMIN_PASSWORD
ARG PRODUCTS
ARG ENTRYPOINT

# Install basis software ...
#   if you use ubuntu:latest, enable ...
# RUN \
#   apt-get update                                && \
#   apt-get upgrade                            -y && \
#   apt-get install curl                       -y

# Install Software AG Installer ...
RUN \
  curl \
    https://empowersdc.softwareag.com/ccinstallers/SoftwareAGInstaller${INSTALLER_VERSION}-Linux_x86_64.bin \
    -o installer.bin

# Create user ...
RUN useradd -ms /bin/bash sagadmin

# Create installation directory ...
RUN mkdir          /opt/softwareag
RUN chown sagadmin /opt/softwareag

# Create script for Software AG Installer ...
RUN \
    echo "ServerURL=https\://sdc-hq.softwareag.com/cgi-bin/dataservewebM`echo ${RELEASE} | sed "s/\.//g"`.cgi"            > installer.script && \
    echo "selectedFixes=spro\:all"                                                                                       >> installer.script && \
    echo "InstallProducts=`for item in $(echo ${PRODUCTS} | sed "s/,/ /g");  do printf e2ei/11/.LATEST/*/$item, ; done`" >> installer.script && \ 
    echo "InstallDir=/opt/softwareag"                                                                                    >> installer.script && \
    echo "adminPassword=${ADMIN_PASSWORD}"                                                                               >> installer.script && \
    echo "Username=${EMPOWER_USERNAME}"                                                                                  >> installer.script && \
    echo "Password=${EMPOWER_PASSWORD}"                                                                                  >> installer.script

RUN echo 'Debug Installer script: ' && echo && cat installer.script

# Install software ...
#   and Change user context to ...
USER sagadmin
RUN sh installer.bin -readScript installer.script -console

# Cleanup ...
USER root
RUN rm installer.bin installer.script

ENV EP=${ENTRYPOINT}
ENTRYPOINT ${EP}

# Work as ...
USER sagadmin
