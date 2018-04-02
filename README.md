# ubuntu-1604-vnc
Docker Container Image of Ubuntu 16.04 with SSHD, XFCE, VNC and more


# My notes on setting it up


# Basic Steps:

* Modify Docker file
* Modify Makefile
* make build


# Push the image to AWS

```bash
ecs-cli push alt_bier/u16vnc
```


# Use docker-compose to create/manage the AWS ECS service

## Create the ecs-cli compose configuration file and start the service

* Add the service in u16vnc.yml
    * Modify limits and ports as needed.  Default opens all 3 ports and has hard limit of 0.25 vCPU and 512M RAM

```yaml
version: '2'
services:
  u16vnc:
    image: 008884162899.dkr.ecr.us-west-2.amazonaws.com/alt_bier/u16vnc:latest
    privileged: true
    cpu_shares: 256
    mem_limit: 536870912
    ports:
     - "522:22/tcp"
     - "5901:5901/tcp"
     - "6901:6901/tcp"
```

Note that privileged mode is required to allow services to modify the network settings since ecs does not support NET_ADMIN

* Push the service into aws ecs and start the service

```bash
ecs-cli compose --file u16vnc.yml --project-name u16vnc up
```

# REFERENCE

* Example on setting up SSHD in a container
    * https://docs.docker.com/engine/examples/running_ssh_service/#run-a-test_sshd-container
* Example on setting up VNC in a container
    * https://github.com/ConSol/docker-headless-vnc-container


