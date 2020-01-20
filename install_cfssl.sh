#!/bin/bash
curl -s -L -o cfssl https://pkg.cfssl.org/R1.2/cfssl_linux-amd64
curl -s -L -o cfssljson https://pkg.cfssl.org/R1.2/cfssljson_linux-amd64
chmod +x cfssl cfssljson
sudo cp cfssl cfssljson /usr/bin/
