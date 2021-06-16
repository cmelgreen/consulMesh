#!/bin/bash

sudo apt-get update

# Install and start Docker
apt install -y docker.io
systemctl start docker

# Install Console
curl -fsSL https://apt.releases.hashicorp.com/gpg | apt-key add -
apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
apt-get update && apt-get install -y consul

# Get Public & Private IP for instance from AWS Metadata API
PRIVATE_IP=$(curl http://169.254.169.254/latest/meta-data/local-ipv4)
PUBLIC_IP=$(curl http://169.254.169.254/latest/meta-data/public-ipv4)

# Enable leave on terminate
touch /opt/consul/config.json
echo '{
    "leave_on_terminate": true
}' >> /opt/consul/config.json

# Start agent
consul agent \
    -data-dir=/opt/consul/ \
    -config-dir=/opt/consul \
    -client=0.0.0.0 \
    -advertise=$PRIVATE_IP \
    -retry-join="provider=aws tag_key=Name tag_value=consul_demo_mesh_server" \
    -enable-local-script-checks &&

# Define service
touch /opt/consul/database.json
echo '{
  "service": {
    "name": "database",
    "port": 5432,
    "connect": { "sidecar_service": {} }
  }
}' >> /opt/consul/database.json

consul reload

consul connect proxy -sidecar-for database

# Start Postgres Database
docker run -d --net=host -e POSTGRES_PASSWORD="consul" postgres
