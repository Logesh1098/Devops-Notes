#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

echo "Updating packages..."
sudo yum update -y

echo "Installing Java (Amazon Corretto 11)..."
sudo amazon-linux-extras enable corretto11
sudo yum install -y java-11-amazon-corretto

echo "Adding Jenkins repository..."
sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key

echo "Installing Jenkins..."
sudo yum install -y jenkins

echo "Enabling and starting Jenkins service..."
sudo systemctl enable jenkins
sudo systemctl start jenkins

echo "Opening firewall port 8080..."
sudo firewall-cmd --permanent --zone=public --add-port=8080/tcp || echo "FirewallD not found or already configured"
sudo firewall-cmd --reload || echo "FirewallD reload skipped"

echo "Jenkins installation complete."
echo "Initial admin password:"
sudo cat /var/lib/jenkins/secrets/initialAdminPassword
