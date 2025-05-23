#!/bin/bash

set -e

info "Installing carpace..."
sudo echo "deb [trusted=yes] https://apt.fury.io/rsteube/ /" | sudo tee /etc/apt/sources.list.d/rsteube.list
sudo apt update
sudo apt install carapace-bin