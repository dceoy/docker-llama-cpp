docker-llama-cpp
================

Dockerfile for llama.cpp

[![CI to Docker Hub](https://github.com/dceoy/docker-llama-cpp/actions/workflows/docker-build-and-push.yml/badge.svg)](https://github.com/dceoy/docker-llama-cpp/actions/workflows/docker-build-and-push.yml)

Docker image
------------

Pull the image from [Docker Hub](https://hub.docker.com/r/dceoy/llama-cpp/).

```sh
$ docker image pull dceoy/llama-cpp
```

Usage
-----

Run a llama.cpp server.

```sh
$ curl -SLO \
    https://huggingface.co/TheBloke/Llama-2-7B-Chat-GGUF/resolve/main/llama-2-7b-chat.Q4_K_M.gguf
$ docker compose run --rm llama-cpp-server \
    --port 8000 --host 0.0.0.0 -n 512 -m /models/llama-2-7b-chat.Q4_K_M.gguf
```
