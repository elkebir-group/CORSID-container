#! /bin/sh

set -euo pipefail

DIR=$(pwd)

# Run CORSID
echo "Begin step 1: CORSID"
docker run -v /${DIR}/test:/test:rw --name corsidData corsid sh -c "corsid -f /test/NC_045512.fasta -g /test/NC_045512.gff -o /test/test.corsid.json > /test/test.corsid.txt"
echo "Finished step 1: CORSID"

echo "Begin step 2: CORSID-Viz"
# docker build -t corsid-viz -f corsid_viz.Dockerfile .
docker run --rm -v /${DIR}/test:/test:rw -p 8080:8080 corsid-viz
echo "Finished step 2: CORSID-Viz"

echo "Begin step 3: BLASTx"
mkdir -p ${DIR}/test/results
docker run --rm \
    -v ${DIR}/test/refseq_taxid11118:/blast/blastdb_custom:ro \
    -v ${DIR}/test/queries:/blast/queries:ro \
    -v ${DIR}/test/results:/blast/results:rw \
    ncbi/blast \
    blastx -query /blast/queries/AC_000192.fasta \
        -db /blast/blastdb_custom/refseq_taxid11118 \
        -out /blast/results/blastx.AC_000192.json \
        -outfmt 15
echo "Finished step 3: BLASTx"