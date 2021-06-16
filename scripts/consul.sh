#!/bin/bash

sudo apt-get update && sudo apt-get upgrade -y

curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
sudo apt-get update && sudo apt-get install -y consul

mkdir /opt/consul

echo '{
    "connect": 
    {
        "enabled": true
    }
}' | tee /opt/consul/db.json

consul agent -server -data-dir=/opt/consul -config-dir=/opt/consul -bootstrap-expect=1 -client=0.0.0.0 -ui -https-port=8501 -grpc-port=8502
