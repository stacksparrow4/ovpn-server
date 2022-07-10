FROM ubuntu:20.04

RUN apt-get update
RUN apt-get install -y openvpn coreutils zip

WORKDIR /etc/openvpn/server
COPY ./openvpn.conf ./server.conf
COPY ./dist/keys.zip ./keys.zip
RUN unzip keys.zip
RUN rm keys.zip

CMD mkdir -p /dev/net && /usr/bin/mknod /dev/net/tun c 10 200 && chmod 600 /dev/net/tun && /usr/sbin/openvpn --config server.conf
