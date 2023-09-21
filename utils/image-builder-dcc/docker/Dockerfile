FROM redhat/ubi8

CMD mkdir /install
COPY dcc_script /install/dcc_script
COPY installer.bin /install/installer.bin 
RUN sh /install/installer.bin -readScript /install/dcc_script

WORKDIR /opt/softwareag

ENTRYPOINT ["/opt/softwareag/common/db/bin/dbConfigurator.sh"]
