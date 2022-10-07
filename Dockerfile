FROM nvcr.io/nvidia/l4t-base:r32.7.1

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
      git gnupg2 \
      python3.8 python3.8-dev python3-pip \
      libopenmpi-dev libomp-dev libopenblas-dev libblas-dev libeigen3-dev

RUN apt-key adv --fetch-key http://repo.download.nvidia.com/jetson/jetson-ota-public.asc
RUN echo 'deb https://repo.download.nvidia.com/jetson/common r32.7 main\n\
deb https://repo.download.nvidia.com/jetson/t210 r32.7 main' > /etc/apt/sources.list.d/nvidia-l4t-apt-source.list
RUN apt-get update

RUN python3.8 -m pip install --upgrade pip
RUN python3.8 -m pip install setuptools gdown

# opencv 4.6.0
RUN apt list --installed | grep -i opencv | xargs apt purge -y
RUN gdown https://drive.google.com/uc?id=1VPU1oUO0_trI8Dm1AJ5UVTEGzqcnl3HU
RUN gdown https://drive.google.com/uc?id=1Z4yKz_5azGbqq3aslc7k0WAwR-yF4Mgc
RUN gdown https://drive.google.com/uc?id=1ZNio67dove9W5kMHqz_nmvmf1GR2y3hQ
RUN gdown https://drive.google.com/uc?id=1_loSh1aD6_FARGhVNFIBz2W4lSw7dfqN
RUN gdown https://drive.google.com/uc?id=1dWN5QWx-8htYURSELGbj4caqHY1228HL
RUN gdown https://drive.google.com/uc?id=1uMfj78AxtDaIirnR5T_qfWsE4Xf8WdJP
RUN apt-get install -y ./OpenCV*.deb

# pytorch 1.11.0
RUN gdown https://drive.google.com/uc?id=1hs9HM0XJ2LPFghcn7ZMOs5qu5HexPXwM
RUN python3.8 -m pip install torch-*.whl

# torchvision 0.12.0
RUN gdown https://drive.google.com/uc?id=1m0d8ruUY8RvCP9eVjZw4Nc8LAwM8yuGV
RUN python3.8 -m pip install torchvision-*.whl

RUN git clone https://github.com/ultralytics/yolov5.git
WORKDIR yolov5
RUN python3.8 -m pip install -r requirements.txt
COPY is_docker.patch .
COPY gstreamer.patch .
RUN patch -p1 < is_docker.patch
