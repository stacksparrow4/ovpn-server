#!/bin/bash

rm -rf dist
mkdir dist
docker build -t vpn-gen -f generate.Dockerfile .
id=$(docker create vpn-gen)
docker cp $id:/root/vpn-server/keys.zip dist/keys.zip
docker cp $id:/root/client1.ovpn dist/client1.ovpn
docker rm -v $id
