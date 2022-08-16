FROM ubuntu:18.04 AS base

RUN echo "APT::Acquire::Retries \"3\";" > /etc/apt/apt.conf.d/80-retries

RUN apt-get update
RUN apt-get install -y gnupg software-properties-common ca-certificates 

RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv E0C56BD4 
RUN add-apt-repository -y ppa:longsleep/golang-backports

RUN apt-get update
ENV TZ=Asia/Kolkata
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y golang-go tzdata runit vim git curl nano

COPY . /usr/share/bytebeam/prometheus-statuspage-pusher
COPY runit/ /etc/runit
RUN rm -rf /etc/runit/runsvdir

RUN cd /usr/share/bytebeam/prometheus-statuspage-pusher && go build

CMD ["/usr/bin/runsvdir", "/etc/runit"]