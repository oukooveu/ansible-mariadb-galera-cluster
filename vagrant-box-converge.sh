#!/bin/bash
set -euo pipefail

sudo systemctl restart chrony || true

[ -f /vagrant_box_converged ] && exit 0

export DEBIAN_FRONTEND=noninteractive

sudo apt purge unattended-upgrades -y

sudo apt-get update && sudo apt-get upgrade -y
sudo apt-get install -y \
    chrony \
    ca-certificates \
    curl \
    gnupg \
    lsb-release \
    net-tools \
    python3-docker \
    python3-venv \
    unzip \
    vim \
    tmux
sudo mkdir -p /etc/apt/keyrings
[ -f /etc/apt/keyrings/docker.gpg ] || curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin

sudo usermod -a -G docker vagrant

# ansible specific
python3 -m venv /home/vagrant/venv
source /home/vagrant/venv/bin/activate
pip install -r /vagrant/requirements.txt -r /vagrant/requirements-dev.txt
sudo chown -R vagrant:vagrant /home/vagrant

touch /vagrant_box_converged
