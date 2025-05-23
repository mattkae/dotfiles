#!/bin/bash

set -e

# Function to print messages
info() {
    echo -e "\e[1;34m[INFO]\e[0m $1"
}

error() {
    echo -e "\e[1;31m[ERROR]\e[0m $1"
}

success() {
    echo -e "\e[1;32m[SUCCESS]\e[0m $1"
}
