#!/bin/bash

if [ $(basename "$(pwd)") != "scripts" ]; then
    echo "Change current directory to scripts first."
    exit 1
fi

letsencrypt_dir="/etc/letsencrypt/live/domain.com"
output_dir="../certs/trusted"

cp $letsencrypt_dir/chain.pem $output_dir/cafile_chain.pem
cp $letsencrypt_dir/cert.pem $output_dir/certfile_cert.pem
cp $letsencrypt_dir/privkey.pem $output_dir/keyfile_privkey.pem

chmod 744 *
chown 1883:1883 *