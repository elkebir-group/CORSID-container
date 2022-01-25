# CORSID-container

This repository contains an analysis pipeline for [CORSID](https://github.com/elkebir-group/CORSID) and docker files for CORSID and [CORSID-viz](https://github.com/elkebir-group/CORSID-viz).
There are three components in this pipeline, CORSID, CORSID-viz, and BLAST.
The pipeline takes a genome in FASTA format as input, running CORSID to annotate genes and identify TRSs, launching a website that shows the visualization of solutions, and BLAST the genes annotated by CORSID.

## Pre-requisites

- Docker
- NCBI's BLAST image

## Installation

1. Pull the NCBI's BLAST image `ncbi/blast`:
    ```bash
    docker pull ncbi/blast
    ```
2. Build CORSID image:
    ```bash
    bash build_corsid.sh
    ```
3. Build CORSID-viz image:
    ```bash
    bash build_corsid.sh
    ```

## Usage

The `workflow.sh` is an example pipeline.
We mount the directories in `test/` to docker containers as input/output path.
You can put the input FASTA file into `test/` (make sure the file extension is `.fasta`) and run `workflow.sh`.
Users are free to change these paths.

For example, there is a genome called `NC_045512.fasta` in `test/` and you can start the pipeline by running the following command.

```bash
bash workflow.sh NC_045512
```

After this script successfully finished, a website will be served at `localhost:8080`, you can copy this path into any browser to view the results of CORSID.

The output files are:

- `test/NC_045512.corsid.json`: annotated genes and TRSs, this file is used for the website
- `test/NC_045512.corsid.gff`: GFF3 file, annotated genes in the optimal solution (the 1st solution in the JSON file)
- `test/NC_045512.corsid.txt`: log output
- `test/results/blastx.NC_045512.json`: BLASTx result of annotated genes in the optimal solution
