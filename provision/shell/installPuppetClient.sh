#!/bin/bash

# Make sure Puppet Client is installed on the host
which puppet
if [[ $? -eq 1 ]]; then
  echo "Puppet Client not installed. Installing..."
  apt-get update && apt-get install -y puppet
else
  echo "Puppet alread installed: "
  puppet --version
fi