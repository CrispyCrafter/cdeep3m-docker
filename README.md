# cdeep3m-docker
Docker Container for running CDEEP3m - CUDA 9.2 - OpenCV 3 - CuDNN 7

To run execute the following steps:

1) Build docker image:

`` sudo docker build . -t cdeep3m:v0.0.1 ``

2) Collect and prepare training data

```
mkdir train
cp -r 'TRAININGFILES AND FOLDERS' train/
```

3) Build docker compose
```
docker-compose build 
```
4) Edit and replace COMMAND in docker-compose.yml      

```
version: '3'
services:
  cdeep3m:
    build:
      dockerfile: Dockerfile
      context: .
    image: cdeep3m
    command: COMMAND  # runtraining.sh COMMAND 
    volumes:
      - ./train:/train
```

5) Run docker-compose up
