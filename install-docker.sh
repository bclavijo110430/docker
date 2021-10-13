#!/bin/bash
sudo sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
sudo sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config
ssh-keygen -A
service ssh restart
mkdir /root/.ssh/

cat /mnt/c/cert/id_rsa.pub >> /root/.ssh/authorized_keys

sudo rm /etc/resolv.conf
sudo bash -c 'echo "nameserver 8.8.8.8" > /etc/resolv.conf'
sudo bash -c 'echo "[network]" > /etc/wsl.conf'
#sudo bash -c 'echo "generateResolvConf = false" >> /etc/wsl.conf'
sudo bash -c 'echo "[automount]" >> /etc/wsl.conf'
sudo bash -c 'echo "root =/mnt/" >> /etc/wsl.conf'
sudo bash -c 'echo "options = metada" >> /etc/wsl.conf'
sudo chattr +i /etc/resolv.conf

sudo apt-get update

sudo apt-get install \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg \
    lsb-release

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

apt-get update 
apt-get install docker-ce docker-ce-cli containerd.io -y

sudo service docker start
sudo service ssh start
exit