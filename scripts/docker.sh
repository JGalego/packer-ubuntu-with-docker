#!/bin/bash

# Update the apt package index
apt update

# Install packages to allow apt to use a repository over HTTPS
apt install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common

# Add Docker’s official GPG key
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

# Set up the stable repository
add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"

# Update the apt package index
apt update

# Install the latest version of Docker Engine - Community and containerd
apt install -y \
    docker-ce \
    docker-ce-cli \
    containerd.io

# Add vagrant to the docker group
sudo usermod -aG docker vagrant

# Verify that Docker Engine - Community is installed correctly
docker run --rm hello-world

# Login to registry
docker login -u $REGISTRY_USERNAME -p $REGISTRY_PASSWORD $REGISTRY_URL

# Pull an image
docker pull $DOCKER_IMAGE
