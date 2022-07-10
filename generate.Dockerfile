FROM ubuntu:20.04

RUN apt-get update
RUN apt-get install -y easy-rsa zip

WORKDIR /root

RUN mkdir ./easy-rsa ./vpn-server
RUN ln -s /usr/share/easy-rsa/* /root/easy-rsa

WORKDIR /root/easy-rsa
RUN ./easyrsa init-pki

COPY ./easy_rsa_vars ./vars
RUN echo "server" | ./easyrsa build-ca nopass

RUN echo "" | ./easyrsa gen-req server nopass
RUN cp ./pki/private/server.key /root/vpn-server/

RUN echo "yes" | ./easyrsa sign-req server server
RUN cp ./pki/issued/server.crt ./pki/ca.crt /root/vpn-server/

RUN mkdir -p /root/clients/keys

RUN echo "" | ./easyrsa gen-req client1 nopass
RUN cp ./pki/private/client1.key /root/clients/keys/

RUN echo "yes" | ./easyrsa sign-req client client1
RUN cp ./pki/issued/client1.crt /root/clients/keys/
RUN cp /root/vpn-server/ca.crt /root/clients/keys/

WORKDIR /root/vpn-server

RUN zip keys.zip ca.crt server.crt server.key

# Generate client1.ovpn
COPY base.ovpn /root/base.ovpn
RUN bash -c "cat /root/base.ovpn <(echo -e '<ca>') /root/clients/keys/ca.crt <(echo -e '</ca>\n<cert>') /root/clients/keys/client1.crt <(echo -e '</cert>\n<key>') /root/clients/keys/client1.key <(echo -e '</key>') > /root/client1.ovpn"
