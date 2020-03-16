#!/usr/bin/env bash
sudo mkdir -p /mnt/gilbert
sudo cryptsetup open /dev/sda1 gilbert_data
sudo mount /dev/mapper/gilbert_data /mnt/gilbert
sudo mount /dev/mapper/gilbert_data /mnt/gilbert

