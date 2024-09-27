#!/bin/bash

if [ $(basename "$(pwd)") != "scripts" ]; then
    echo "Change current directory to scripts first."
    exit 1
fi

output_dir="./outputs"

openssl genrsa -out  $output_dir/ca_server.key 2048

openssl req \
    -new \
    -x509 \
    -days 1826 \
    -key $output_dir/ca_server.key \
    -out $output_dir/ca_server.crt

openssl genrsa -out $output_dir/server.key 2048

openssl req \
    -new \
    -out $output_dir/server.csr \
    -key $output_dir/server.key \
    -config server.conf

openssl x509 \
    -req \
    -in $output_dir/server.csr \
    -CA $output_dir/ca_server.crt \
    -CAkey $output_dir/ca_server.key \
    -CAcreateserial \
    -out $output_dir/server.crt \
    -days 360 \
    -extfile server.conf \
    -extensions v3_req

rm $output_dir/*.csr && rm $output_dir/*.srl
chmod 744 $output_dir/*
chown 1883:1883 $output_dir/*
openssl verify -CAfile $output_dir/ca_server.crt $output_dir/server.crt