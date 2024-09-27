#!/bin/bash

if [ $(basename "$(pwd)") != "scripts" ]; then
    echo "Change current directory to scripts first."
    exit 1
fi

ca_client_dir="../certs/client"
output_dir="./outputs"

read -p "Enter client name: " NAME
echo

echo "(!) ---------------------------------------------- (!)"
echo " |    Common name must be included (client name)    |"
echo "(!) ---------------------------------------------- (!)"

echo
echo

openssl genrsa \
    -out $output_dir/client-$NAME.key 2048

openssl req \
    -new \
    -out $output_dir/client-$NAME.csr \
    -key $output_dir/client-$NAME.key

openssl x509 \
    -req \
    -in $output_dir/client-$NAME.csr \
    -CA $ca_client_dir/ca_client.crt \
    -CAkey $ca_client_dir/ca_client.key \
    -CAcreateserial \
    -out $output_dir/client-$NAME.crt \
    -days 360

rm $ca_client_dir/ca_client.srl
rm $output_dir/client-$NAME.csr
openssl verify -CAfile $ca_client_dir/ca_client.crt $output_dir/client-$NAME.crt