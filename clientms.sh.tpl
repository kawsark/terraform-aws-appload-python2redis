#!/bin/bash
#Install Docker
sudo apt-get update -y
sudo apt-get install \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common -y
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo apt-key fingerprint 0EBFCD88
sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"
sudo apt-get update -y
sudo apt-get install docker-ce docker-ce-cli containerd.io -y
groupadd docker
usermod -aG docker ubuntu
systemctl enable docker

#Download application and build image
cd /tmp && git clone https://github.com/kawsark/redis-client-service.git -b password
cd redis-client-service && sudo docker build -t python-clientms .

sudo docker run --network host --name clientms -d -e REDIS_HOST="${redis_host}" -e REDIS_PORT="${redis_port}" -e REDIS_PASSWORD="${redis_password}" -p 5000:5000 --restart unless-stopped python-clientms
