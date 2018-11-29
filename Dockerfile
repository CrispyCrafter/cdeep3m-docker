FROM nvidia/cuda:9.2-cudnn7-devel-ubuntu16.04

# Build deps
RUN useradd -ms /bin/bash cdeep3m

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
	    cpio \
        build-essential \
        cmake \
        wget \
        ssh \
        numactl \
        net-tools \
        iputils-ping \
        screen \
        libmlx4-1 libmlx5-1 ibutils  rdmacm-utils libibverbs1 ibverbs-utils perftest  \
        openmpi-bin libopenmpi-dev \
        ufw \
        python-dev \
        python-numpy \
        python-pip \
        python-setuptools \
        python-scipy \ 
        python-opencv \
        libblas-dev \
        liblapack-dev\
        libatlas-dev \
        libatlas3-base\
        libatlas-base-dev\
        libprotobuf-dev \
        libleveldb-dev \ 
        libsnappy-dev \
        libopencv-dev \
        libboost-all-dev \
        libhdf5-serial-dev \
        libgflags-dev \
        libgoogle-glog-dev \ 
        liblmdb-dev \
        protobuf-compiler \
        libboost-all-dev \
        build-essential \
        cmake \
        git \
        pkg-config \
        libjpeg8-dev \
        libjasper-dev \
        libpng12-dev \
        libgtk2.0-dev \
        libavcodec-dev \
        libavformat-dev \
        libswscale-dev \
        libv4l-dev gfortran \
        libleveldb1v5 libleveldb-dev \
        parallel \
        kate && \
        rm -rf /var/lib/apt/lists/*

# Build HDF5
RUN apt-get update && apt-get install -y software-properties-common && \ 
    apt-add-repository ppa:octave/stable && \   
    apt-get install -y --no-install-recommends octave octave-image octave-pkg-dev 

RUN wget https://github.com/stegro/hdf5oct/archive/b047e6e611e874b02740e7465f5d139e74f9765f.tar.gz  && \
    mkdir /home/nd_sense/  && mkdir /home/nd_sense/HDF5 && \ 
    mv b047e6e611e874b02740e7465f5d139e74f9765f.tar.gz /home/nd_sense/HDF5/hdf5.tar.gz && \
    tar -xf /home/nd_sense/HDF5/hdf5.tar.gz -C /home/nd_sense/HDF5 && \
    mv /home/nd_sense/HDF5/hdf5oct-b047e6e611e874b02740e7465f5d139e74f9765f /home/nd_sense/HDF5/HDF5-oct && \
    rm /home/nd_sense/HDF5/hdf5.tar.gz

WORKDIR /home/nd_sense/HDF5/HDF5-oct
RUN make  && \ 
    make install 

# Build BATS

RUN mkdir /home/nd_sense/BATS && \
    cd /home/nd_sense/BATS

WORKDIR /home/nd_sense/BATS

RUN git clone https://github.com/bats-core/bats-core.git && \
    cd bats-core && \
    ./install.sh /usr/local

# Build Caffe

COPY requirements.txt /home/nd_sense/requirements.txt
RUN pip install --upgrade pip &&\
    pip2 install setuptools --upgrade && \
    pip2 install wheel &&\
    pip2 install -r /home/nd_sense/requirements.txt

RUN find . -type f -exec sed -i -e 's^"hdf5.h"^"hdf5/serial/hdf5.h"^g' -e 's^"hdf5_hl.h"^"hdf5/serial/hdf5_hl.h"^g' '{}' \; 
RUN  cd /usr/lib/x86_64-linux-gnu && \
     ln -s libhdf5_serial.so.8.0.2 libhdf5.so && \
     ln -s libhdf5_serial_hl.so.8.0.2 libhdf5_hl.so 

RUN dpkg -L libblas-dev && dpkg -L libblas-dev 

RUN git clone https://github.com/CrispyCrafter/caffe_nd_sense_segmentation.git && \
    mv caffe_nd_sense_segmentation/ /home/nd_sense/

COPY Makefile.config /home/nd_sense/caffe_nd_sense_segmentation/Makefile.config
WORKDIR /home/nd_sense/caffe_nd_sense_segmentation

RUN make all -j $(($(nproc) + 1)) 

WORKDIR /home/cdeep3m
RUN wget https://github.com/CRBS/cdeep3m/archive/v1.6.2.tar.gz && \
    tar --strip-components=1 -zxf v1.6.2.tar.gz 

RUN mkdir /train

ENV PATH="/home/cdeep3m/:${PATH}"

ENTRYPOINT  [ "runtraining.sh" ]
#ENTRYPOINT  [ "runprediction.sh", "/train/sbem/mitochrondria/xy5.9nm40nmz/30000iterations_train_out",  "/home/cdeep3m/cdeep3m-1.6.2/mito_testsample/testset/", "/train/predictout30k" ]
# CMD [ "runprediction.sh", "train/train_out/",  "mito_testsample/testset/", "train/predictout30k" ]
 