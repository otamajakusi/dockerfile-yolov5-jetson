FROM nvcr.io/nvidia/l4t-base:r32.5.0

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y --no-install-recommends python3.8 python3-pip

RUN python3.8 -m pip install --upgrade pip
RUN python3.8 -m pip install setuptools gdown

COPY numpy*.whl .
COPY opencv_python-*.whl .

RUN python3.8 -m pip install numpy*.whl opencv_python-*.whl

RUN gdown https://drive.google.com/uc?id=1V231Nmx42vXTo5nq_YsV_BouZwBE9vjh
# RUN wget https://nvidia.box.com/shared/static/p57jwntv436lfrd78inwl7iml6p13fzh.whl -O torch-1.8.0-cp36-cp36m-linux_aarch64.whl
RUN python3.8 -m pip install torch-1.8.0a0+56b43f4-cp38-cp38-linux_aarch64.whl

COPY torchvision-*.tar.gz .
RUN tar xf torchvision-*.tar.gz -C /

RUN apt-get install -y --no-install-recommends git
RUN git clone https://github.com/ultralytics/yolov5.git
RUN cd yolov5 && python3.8 -m pip install -r requirements.txt
WORKDIR /yolov5

RUN apt-get install -y --no-install-recommends libomp5 libopenmpi-dev
RUN apt-get install -y --no-install-recommends libopenblas-base
RUN apt-get install -y --no-install-recommends libgtk2.0-dev
