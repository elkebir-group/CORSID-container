FROM amazonlinux:latest

RUN yum update -y && \
    yum install -y python3 python3-devel

RUN pip3 install --no-cache-dir corsid==0.1.2

RUN corsid -h
