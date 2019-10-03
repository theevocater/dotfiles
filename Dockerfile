FROM ubuntu:disco

COPY bootstrap/ /root/bootstrap
RUN /root/bootstrap/00-packages.sh

