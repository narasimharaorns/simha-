#!/bin/bash

sleep 60

# Generate SSH Key for Passwordless configurations
yes '' | ssh-keygen -N '' -f /home/devops/.ssh/id_rsa > /dev/null

echo export KOPS_CLUSTER_NAME=euwest.dev.rnstech.com >> /home/devops/.bashrc
echo export KOPS_STATE_STORE=s3://clusters.dev.rnstech.com >> /home/devops/.bashrc

source /home/devops/.bashrc

env

kops create cluster --state=${KOPS_STATE_STORE} --node-count=2 --zones=eu-west-1a,eu-west-1b --name=${KOPS_CLUSTER_NAME} --dns private --master-count 1
kops update cluster --name ${KOPS_CLUSTER_NAME} --state ${KOPS_STATE_STORE} --yes --admin
