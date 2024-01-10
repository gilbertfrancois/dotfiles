#!/usr/bin/env bash

export CLI=ngccli_cat_linux.zip

cd /tmp
mkdir -p download
wget "https://ngc.nvidia.com/downloads/$CLI"
unzip -u "ngc_assets/ngccli/${CLI}" -d download/
sudo cp -r download/ngc-cli /opt
rm -rf download ${CLI}
