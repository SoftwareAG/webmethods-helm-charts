# Container Image Creation for MyWebMethods Server

Use the build.sh to create a MyWebMethods Server instance.

## Prerequisites

Set the following variables for accessing Empower:

```
export EMPOWER_USER=<your Empower user>
export EMPOWER_PASSWORD=<your Empower password>
```

## Building

Execute build.sh example:

```
build.sh mws:10.15.0.5 manage
```

Which will create a MWS image with the tag 10.15.0.5 and use manage as the default admin password.