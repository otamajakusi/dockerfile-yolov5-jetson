FROM nvcr.io/nvidia/l4t-base:r32.5.0

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y --no-install-recommends \
	python3.8 python3-pip git \
	libomp5 libopenmpi-dev libopenblas-base libgtk2.0-dev

RUN python3.8 -m pip install --upgrade pip
RUN python3.8 -m pip install setuptools gdown

COPY numpy-*.whl .
RUN python3.8 -m pip install numpy*.whl

COPY opencv_python-*.whl .
RUN python3.8 -m pip install opencv_python-*.whl

COPY torch-*.whl .
RUN python3.8 -m pip install torch-*.whl

#RUN gdown https://drive.google.com/uc?id=1V231Nmx42vXTo5nq_YsV_BouZwBE9vjh
# RUN wget https://nvidia.box.com/shared/static/p57jwntv436lfrd78inwl7iml6p13fzh.whl -O torch-1.8.0-cp36-cp36m-linux_aarch64.whl
#RUN python3.8 -m pip install 

COPY torchvision-*.tar.gz .
RUN tar xf torchvision-*.tar.gz -C /

RUN git clone https://github.com/ultralytics/yolov5.git
RUN cd yolov5 && python3.8 -m pip install -r requirements.txt
WORKDIR /yolov5
