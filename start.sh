#!/bin/bash
sudo docker-compose up --build -d || exit 1

./launch.sh || exit 1

exit 0
