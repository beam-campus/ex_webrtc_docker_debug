# ex_webrtc_docker_debug

This repository contains a minimalistic elixir application that adds the dependencies ex_webrtc and ex_sctp. Its  purpose is to build a minimal elixir application capable of running from a docker container and debugging it.

## How to run

- to run the containerized application, you need to have docker and docker-compose installed. Then, you can run the following command:

```bash
cd system
./dbg-compose.sh
```
PLEASE NOTE: dbg-compose.sh will create a directory */min_webrtc/*!   
The release will be located in that directory, allowing you to run it from the host machine.

- to run the release from the host machine, you can run the following command:

```bash
cd system
./dbg-local.sh
```


