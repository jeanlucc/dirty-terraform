#!/bin/sh
set -e
set -x

sudo apt-get update
sudo apt-get update # here because the first one finishes before docker-compose install and thus the package is not found (only in remote-exec) works manually
sudo apt-get install -y docker-compose
ssh-keyscan -H github.com >> ~/.ssh/known_hosts
git clone git@github.com:jeanlucc/test-scalability.git
cd test-scalability
sudo docker-compose up -d
