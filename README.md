# **Quality Insights for RNA-Seq Alignment with STAR**


## Background & Rationale

Transcriptome data is increasingly analyzed in computational biology research as the dataset that reveals insights into the gene expression of organsisms. Compared to analyzing the genome, the transcriptome is able to track how an orgnism is actively carrying out cellular processes with genes and proteins. In order to unearth information from the trasncriptome, sequencing must be performed on a sample, and those sequences must be aligned to an indexed genome. Thus, it is highly important to use computational tools for RNA-seq that allow researchers to analyze RNA quickly and accurately. 

STAR (Spliced Transcripts Alignment to a Reference) is a tool widely used for RNA-seq analysis. It is regarded as one of the fastest and accurate aligners available and is curated for RNA data. STAR features splice-aware alignement as it reads across exon-exon junctions, so the software has greater understadning of where splicing occurs. STAR has high speed and fidelity and can handle large datasets and genomes as well as both single and paired-end seqeuncing. STAR will create an index with a `.fna` file with the genome and a `.gtf` file with annotations. Then, it is able to take `.fastq` files to align sequences to the indexed genome. It outputs SAM/BAM files for viewing in programs such as IGV, as a `ReadsPerGene.out.tab` file which contains gene counts for downstream processes such as PCA plotting or differential expression analysis. In every ReadsPerGene.out.tab file, there is metadata at the top that contains information about the number of reads that are "N_unmapped", "N_multimapping", "N_noFeature", and "N_ambiguous". Respectively, these terms refer to the number of genes that were unsucccesfuly mapped to the genome, mapped to multiple locations in the genome, genes that do not overlap with any known features, and genes that map to multiple features. This reveals important data about the status of how reads were aligned with the genome and adds insights into the quality and interpretability of the data. It is important to procure both data to use for further analysis as well as understand what limitations the working data may have. 


## Pipeline

This pipeline uses single-end RNA sequencing fastq reads from E. coli to understand and compare the transcriptome when bacterial cells are subject to anaerobic-aerobic transition. It aims to generate fastqc reports for all samples, 2 sample files for control - cells grown in anaerobic conditions, and 2 sample files for cells subject to 10 minutes of aeration after being grown in anaerobic conditions. Then, a star genome index with reference genome and annotation files in order to perform star alignment. 4 alignments are carried out, one for each sample in order to provide adequate data for potential downstream gene expression analysis. The main end-product in this pipeline would be the visual that displays a proportion of gene metrics corresponding to "N_unmapped", "N_multimapping", "N_noFeature", and "N_ambiguous" reads. Combined with the FASTQC reports, this provides insights into the quality of RNA sequencing data.  

<img width="638" alt="Screenshot 2024-12-04 at 7 44 34 PM" src="https://github.com/user-attachments/assets/b4126c01-2327-4750-ae9e-f2cbcc3febd5">


As part of your project, you must:
◦ Describe the dataset, providing full accession details, number of individuals in the cohort,
type of data (DNA, RNA, methylation, etc) and other relevant metadata
◦ Some tools may accept several datasets or types (be specific and document flexibility)

◦ Clearly describe your environment (python version, NextFlow version, package versions, etc)
Workflow creation




## **Usage**


***Pre-requisites***

- Docker Desktop version 4.35.1 - [Install](https://docs.docker.com/get-started/get-docker/)
- Nextflow version 24.10.0 - [Install](https://www.nextflow.io/docs/latest/install.html)



***Running the Pipeline***

1. `cd` into your preferred working directory
   
2. Clone this repository

  ``` git clone https://github.com/Maplelei1/BIOF501Proj.git ```

3. Pull the Docker container

  ``` docker pull yangwu91/bioinfo ```

5. Run code with the `nextflow` command with docker

  ``` nextflow run main1000.nf -with-docker ```
   
7. Sometimes, the pipeline runs in seconds. Sometimes, it seems to get stuck for a while. For subsequent runs, please `ctrl-C` to cancel the job and use the code below to ensure you do not need to repeat any previously cached processes

   ``` nextflow run main1000.nf -with-docker -resume ```

   

### Container

This pipeline uses a Docker container called `yangwu91/bioinfo` that has a relevant assortment of pre-installed bioinformatics utilities. You can find the git for the container [here](https://github.com/yangwu91/bioinfo-docker).

fastqc - v0.12.1

Another container is the `quay.io/biocontainers/star:2.7.11b--h43eeafb_3` which contains:

star - 2.7.11b



## **Inputs**

**fastq files***

The single-end RNA sequencing data can be found [here](https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE71562)  
This repository uses a subsetted version of the `.fastq` files from the following SRA accession codes:

SRR2135663 - Control1
SRR2135669 - Control2
SRR2135668 - Treatment1
SRR2135674 - Treatment2

Subsetting the files into 1000 reads was completed by the following commad:

```seqtk sample -s100 SRR2135663.fastq 1000 > 1000sub_control1.fastq ```

Below are the



## **Outputs**

Below are some sample graphs from the first FASTQC HTML report named `1000sub_control1_fastqc.html`. All output can be found in the `work/` directory within the appropriate subdirectory as indicated by the nextflow process. 

``` /work/.../.../1000sub_control1_fastqc.html ```

<img width="656" alt="Screenshot 2024-12-04 at 2 33 03 AM" src="https://github.com/user-attachments/assets/65a79130-b387-48fe-8aad-817c5fc635c1">


<img width="656" alt="Screenshot 2024-12-04 at 2 33 16 AM" src="https://github.com/user-attachments/assets/dccf2fda-f9d5-48b0-b78e-a7f359fcec43">

``` /work/.../.../gene_metadata_proportions_with_percentages.png ```

The last process, `GENE_METADATA_PROPORTIONS` produces a `.png` file that visualizes the porpotion of reads that are ambiguous, multimapped, unmapped, or having no features. 

<img width="612" alt="Screenshot 2024-12-04 at 2 31 07 AM" src="https://github.com/user-attachments/assets/cfb19789-eea8-47a9-aabc-9e00f4108b97">


