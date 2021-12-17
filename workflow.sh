#! /bin/sh

set -euo pipefail

DIR=$(pwd)
SAMPLE="NC_045512"

# Run CORSID
echo "Begin step 1: CORSID"
docker run --rm \
    -v /${DIR}/test:/test:rw \
    --name corsidData \
    corsid \
    sh -c "corsid -f /test/${SAMPLE}.fasta -g /test/${SAMPLE}.gff -o /test/test.corsid.json > /test/test.corsid.txt"
echo "Finished step 1: CORSID"

echo "Begin step 2: CORSID-Viz"
# docker build -t corsid-viz -f corsid_viz.Dockerfile .
docker run -d \
    -v /${DIR}/test:/test:ro \
    -p 8080:8080 \
    corsid-viz \
    /bin/bash -c "cp /test/test.corsid.json src/assets/result.json && npx vue-cli-service build --mode singleton && serve -s dist -p 8080"
echo "Finished step 2: CORSID-Viz"

echo "Begin step 3: BLASTx"
mkdir -p ${DIR}/test/results
docker run --rm \
    -v /${DIR}/test/refseq_taxid11118:/blast/blastdb_custom:ro \
    -v /${DIR}/test/queries:/blast/queries:ro \
    -v /${DIR}/test/results:/blast/results:rw \
    ncbi/blast \
    blastx -query /blast/queries/AC_000192.fasta \
        -db /blast/blastdb_custom/refseq_taxid11118 \
        -out /blast/results/blastx.AC_000192.json \
        -outfmt 15
echo "Finished step 3: BLASTx"