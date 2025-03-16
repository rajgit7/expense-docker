#!/bin/bash

#check whether root user or not
# Text color variables
RED="\e[31m"
GREEN="\e[32m"
YELLOW="\e[33m"
BLUE="\e[34m"
NC="\e[0m" # No Color

# Set architecture
ARCH=amd64
PLATFORM=$(uname -s)_$ARCH

# Start eksctl installation
echo -e "${YELLOW}Starting eksctl installation...${NC}"

# Download eksctl
echo -e "${BLUE}Downloading eksctl for $PLATFORM...${NC}"
if curl -sLO "https://github.com/eksctl-io/eksctl/releases/latest/download/eksctl_$PLATFORM.tar.gz"; then
    echo -e "${GREEN}Downloaded eksctl_$PLATFORM.tar.gz${NC}"
else
    echo -e "${RED}Failed to download eksctl.${NC}" >&2
    exit 1
fi

# Extract and install eksctl
echo -e "${BLUE}Extracting eksctl...${NC}"
tar -xzf eksctl_$PLATFORM.tar.gz -C /tmp && rm eksctl_$PLATFORM.tar.gz
sudo mv /tmp/eksctl /usr/local/bin

# Start kubectl installation
echo -e "${YELLOW}Starting kubectl installation...${NC}"

# Download kubectl
echo -e "${BLUE}Downloading kubectl...${NC}"
if curl -O "https://s3.us-west-2.amazonaws.com/amazon-eks/1.31.0/2024-09-12/bin/linux/amd64/kubectl"; then
    echo -e "${GREEN}Downloaded kubectl${NC}"
else
    echo -e "${RED}Failed to download kubectl.${NC}" >&2
    exit 1
fi

# Make kubectl executable
chmod +x ./kubectl

# Move kubectl to the user's local bin
mkdir -p $HOME/bin
cp ./kubectl $HOME/bin/kubectl
export PATH=$HOME/bin:$PATH

# Move kubectl to /usr/local/bin
sudo mv ./kubectl /usr/local/bin/kubectl

# Verify kubectl installation
echo -e "${YELLOW}Verifying kubectl installation...${NC}"
if kubectl version; then
    echo -e "${GREEN}kubectl installation successful!${NC}"
else
    echo -e "${RED}kubectl installation failed!${NC}" >&2
    exit 1
fi

# kubens
git clone https://github.com/ahmetb/kubectx /opt/kubectx
ln -s /opt/kubectx/kubens /usr/local/bin/kubens
VALIDATE $? "kubens installation"


Helm
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
chmod 700 get_helm.sh
./get_helm.sh
VALIDATE $? "helm installation"

#kubectx
sudo git clone https://github.com/ahmetb/kubectx /opt/kubectx
sudo ln -s /opt/kubectx/kubectx /usr/local/bin/kubectx
sudo ln -s /opt/kubectx/kubens /usr/local/bin/kubens
kubens