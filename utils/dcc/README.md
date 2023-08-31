# Database Configurator Component Container Image build

Sample Dockerfile and scripts to create a DB Configurator image in order to ease the creation of DB assets for webMethods components. You need a Docker installed and [Empower](https://empower.softwareag.com) credentials.

Set environment variable `EMPOWER_USER` and `EMPOWER_PASSWORD` in your Shell and start

```
cd docker
./build.sh
```

At the end, an image `dcc:latest` with entrypoint `/opt/softwareag/common/db/bin/dbConfigurator.sh` is created.
