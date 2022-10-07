FROM nvcr.io/nvidia/l4t-base:r32.7.1

ENV DEBIAN_FRONTEND=noninteractive

RUN apt update && apt install -y \
      python3.8 python3.8-dev python3-pip \
      libopenmpi-dev libomp-dev libopenblas-dev libblas-dev libeigen3-dev \
      nvidia-cuda nvidia-cudnn8

RUN python3.8 -m pip install --upgrade pip
RUN python3.8 -m pip install setuptools gdown

# pytorch 1.11.0
RUN gdown https://drive.google.com/uc?id=1hs9HM0XJ2LPFghcn7ZMOs5qu5HexPXwM
RUN python3.8 -m pip install torch-*.whl

# torchvision 0.12.0
https://drive.google.com/file/d/1m0d8ruUY8RvCP9eVjZw4Nc8LAwM8yuGV/view?usp=sharing
RUN python3.8 -m pip install torchvision-*.whl

RUN git clone https://github.com/ultralytics/yolov5.git -b v6.1
RUN cd yolov5 && python3.8 -m pip install -r requirements.txt
WORKDIR /yolov5
