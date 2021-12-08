#! /bin/sh

set -euo pipefail

DIR=$(pwd)

# Run CORSID
echo "Begin step 1: CORSID"
docker run -v /${DIR}/test:/test:rw --name corsidData corsid sh -c "corsid -f /test/NC_045512.fasta -g /test/NC_045512.gff -o /test/test.corsid.json > /test/test.corsid.txt"
echo "Finished step 1: CORSID"
echo "Begin step 2: CORSID-Viz"
# docker build -t corsid-viz -f corsid_viz.Dockerfile .
# docker run -v /${DIR}/test:/test:rw corsid-viz
echo "Finished step 2: CORSID-Viz"