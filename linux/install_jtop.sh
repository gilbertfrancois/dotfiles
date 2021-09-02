#!/usr/bin/env bash
 
sudo apt update
sudo apt install python3-pip

sudo -H /usr/bin/pip3 install jetson-stats
sudo /bin/systemctl restart jetson_stats.service
