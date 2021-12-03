#!/bin/bash

set -euo pipefail

docker build -t corsid-viz -f corsid_viz.Dockerfile .
echo "build finished"
docker run --name vue_app_container --rm -it -d -p 8080:8080 corsid-viz
