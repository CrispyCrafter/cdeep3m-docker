# cdeep3m-docker
Docker container for running CDEEP3m - CUDA 9.0 - OpenCV 2 - CuDNN 7

Dependencies:

1) [docker](https://www.digitalocean.com/community/tutorials?q=+How+To+Install+and+Use+Docker+on+Ubuntu) & [docker-compose](https://www.digitalocean.com/community/tutorials?q=Docker+Compose+on+Ubuntu)  
2) [nvidia-docker](https://github.com/NVIDIA/nvidia-docker) 

To run execute the following steps:

1) Collect and prepare training data

```
mkdir train
cp -r 'TRAININGFILES AND FOLDERS' train/
```

2) Build docker compose
```
docker-compose build 
```
3) Edit and replace COMMAND in docker-compose.yml      

```
version: '2.3'
services:
  cdeep3m:
    build:
      dockerfile: Dockerfile
      context: .
    image: cdeep3m
    runtime: nvidia
    environment:
      - NVIDIA_VISIBLE_DEVICES=all
    command: COMMAND # runtraining.sh COMMAND 
    volumes:
      - ./train:/train
```

4) Run:
``` 
docker-compose up
```
5) If rebuilding docker-compose image after changes to cdeep3m master run:
```
docker-compose build --no-cache
```
