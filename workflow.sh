#! /bin/sh

set -euo pipefail

DIR=$(pwd)
SAMPLE=$1

# Run CORSID
echo "Begin step 1: CORSID"
if [[ -f "${DIR}/test/${SAMPLE}.gff" ]]; then
    command="corsid -f /test/${SAMPLE}.fasta -g /test/${SAMPLE}.gff -o /test/${SAMPLE}.corsid.json -r /blast/queries/${SAMPLE}.corsid.fasta > /test/${SAMPLE}.corsid.txt"
else
    command="corsid -f /test/${SAMPLE}.fasta -o /test/${SAMPLE}.corsid.json -r /blast/queries/${SAMPLE}.corsid.fasta > /test/${SAMPLE}.corsid.txt"
fi
echo $command

docker run --rm \
    -v /${DIR}/test:/test:rw \
    -v /${DIR}/test/queries:/blast/queries:rw \
    --name corsidData \
    corsid \
    sh -c "${command}"
echo "Finished step 1: CORSID"

echo "Begin step 2: CORSID-Viz"
# docker build -t corsid-viz -f corsid_viz.Dockerfile .
docker run -d \
    -v /${DIR}/test:/test:ro \
    -p 8080:8080 \
    corsid-viz \
    /bin/bash -c "cp /test/${SAMPLE}.corsid.json src/assets/result.json && npx vue-cli-service build --mode singleton && serve -s dist -p 8080"
echo "Finished step 2: CORSID-Viz"

echo "Begin step 3: BLASTx"
mkdir -p ${DIR}/test/results
docker run --rm \
    -v /${DIR}/test/refseq_taxid11118:/blast/blastdb_custom:ro \
    -v /${DIR}/test/queries:/blast/queries:ro \
    -v /${DIR}/test/results:/blast/results:rw \
    ncbi/blast \
    blastx -query /blast/queries/${SAMPLE}.corsid.fasta \
        -db /blast/blastdb_custom/refseq_taxid11118 \
        -out /blast/results/blastx.${SAMPLE}.json \
        -outfmt 15
echo "Finished step 3: BLASTx"