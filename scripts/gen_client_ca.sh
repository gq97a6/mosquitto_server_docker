#!/bin/bash

if [ $(basename "$(pwd)") != "scripts" ]; then
    echo "Change current directory to scripts first."
    exit 1
fi

output_dir="./outputs"

openssl genrsa -out  $output_dir/ca_client.key 2048
openssl req \
    -new \
    -x509 \
    -days 1826 \
    -key $output_dir/ca_client.key \
    -out $output_dir/ca_client.crt

chmod 744 $output_dir/ca_client.crt
chown 1883:1883 $output_dir/ca_client.crt