#! /bin/bash
#
#
# Remove the existing directory
echo "Removing min-webrtc directory"
sudo rm -rf /min_webrtc

## MACULA EDGE
echo "Creating min-webrtc directory"
sudo mkdir -p /min_webrtc
sudo chmod 777 /min_webrtc

docker compose up --build
