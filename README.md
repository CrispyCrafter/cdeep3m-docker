# cdeep3m-docker
Docker Container for running CDEEP3m - CUDA 9.2 - OpenCV 3 - CuDNN 7

To run execute the following steps:

1) Build docker image:

`` sudo docker build . -t cdeep3m:v0.0.1 ``

2) Collect sample training data

````
mkdir train
 wget https://s3-us-west-2.amazonaws.com/cdeep3m-trainedmodels/sbem/mitochrondria/xy5.9nm40nmz/sbem_mitochrondria_xy5.9nm40nmz_30000iter_trainedmodel.tar.gz 
 tar -xf sbem_mitochrondria_xy5.9nm40nmz_30000iter_trainedmodel.tar.gz -C train/
 rm sbem_mitochrondria_xy5.9nm40nmz_30000iter_trainedmodel.tar.gz
````

3) To run Container (runtraining.sh)

`` sudo docker run -it cdeep3m:v0.0.1 --version ``

