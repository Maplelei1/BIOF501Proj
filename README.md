# **Quality Insights for RNA-Seq Alignment with STAR**

## Background & Rationale

Transcriptome data is increasingly analyzed in computational biology research as the dataset that reveals insights into the gene expression of organsisms. Compared to analyzing the genome, the transcriptome is able to track how an orgnism is actively carrying out cellular processes with genes and proteins. In order to unearth information from the trasncriptome, sequencing must be performed on a sample, and those sequences must be aligned to an indexed genome. Thus, it is highly important to use computational tools for RNA-seq that allow researchers to analyze RNA quickly and accurately. 

STAR (Spliced Transcripts Alignment to a Reference) is a tool widely used for RNA-seq analysis. It is regarded as one of the fastest and accurate aligners available and is curated for RNA data. STAR features splice-aware alignement as it reads across exon-exon junctions, so the software has greater understadning of where splicing occurs. STAR has high speed and fidelity and can handle large datasets and genomes as well as both single and paired-end seqeuncing. STAR will create an index with a .fna file with the genome and a .gtf file with annotations. Then, it is able to take .fastq files to align sequences to the indexed genome. It outputs SAM/BAM files for viewing in programs such as IGV, as a ReadsPerGene.out.tab file which contains gene counts for downstream processes such as PCA plotting or differential expression analysis. In every ReadsPerGene.out.tab file, there is metadata at the top that contains information about the number of reads that are "N_unmapped", "N_multimapping", "N_noFeature", and "N_ambiguous". Respectively, these terms refer to the number of genes that were unsucccesfuly mapped to the genome, mapped to multiple locations in the genome, genes that do not overlap with any known features, and genes that map to multiple features. This reveals important data about the status of how reads were aligned with the genome and adds insights into the quality and interpretability of the data. It is important to procure both data to use for further analysis as well as understand what limitations the working data may have. 

## Pipeline

This pipeline uses single-end RNA sequencing fastq reads from E. coli to understand and compare the transcriptome when bacterial cells are subject to anaerobic-aerobic transition. It aims to generate fastqc reports for all samples, 2 sample files for control - cells grown in anaerobic conditions, and 2 sample files for cells subject to 10 minutes of aeration after being grown in anaerobic conditions. Then, a star genome index with reference genome and annotation files in order to perform star alignment. 4 alignments are carried out, one for each sample in order to provide adequate data for potential downstream gene expression analysis. The main end-product in this pipeline would be the visual that displays a proportion of gene metrics corresponding to "N_unmapped", "N_multimapping", "N_noFeature", and "N_ambiguous" reads. Combined with the FASTQC reports, this provides insights into the quality of RNA sequencing data.  

• include the what’s and why’s – also your aims
• include any package dependencies that are required (bullet points are ok for this)
• You can include your DAG here

<img width="638" alt="Screenshot 2024-12-04 at 7 44 34 PM" src="https://github.com/user-attachments/assets/b4126c01-2327-4750-ae9e-f2cbcc3febd5">

The single-end RNA sequencing data can be found [here] (https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE71562) 

## Data 

The single-end RNA sequencing data can be found here.  https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE71562 

As part of your project, you must:
◦ Describe the dataset, providing full accession details, number of individuals in the cohort,
type of data (DNA, RNA, methylation, etc) and other relevant metadata
◦ Some tools may accept several datasets or types (be specific and document flexibility)
◦ Clearly define your control and test groups
◦ Clearly state your hypothesis, aims and objectives
◦ Clearly describe your environment (python version, NextFlow version, package versions, etc)
Workflow creation


The Standard Operating Procedure (SOP) must provide details on:
◦ Information about the pipeline and what it aims to do
◦ Expected results
◦ Usage instructions so that another person can replicate your results
◦ The setup of the environment as well as package versions so that it can be replicated
easily
◦ Information about the data used in the analysis (source, accession date, number of
samples, disease status, etc.)
◦ Any accessory programs that will be called (including version numbers)
Workflow creation





**Usage**
Make sure you format everything so that step by step usage details are included. If we can’t run your
pipeline then we can’t give you marks.
• Installation (if necessary) including any datasets that are to be used if they are not provided
(i.e. how to download them using wget or curl – exact paths need to be specified and the data
must be accessible)
• Exact step by step usage with descriptive comments on what action is being performed in each
step

**Input**
Describe the format of the input data, explaining all fields.

**Output**
Describe the format of the output including files and visualizations. Treat this section like the results of
a paper. You can look at readthedocs pages of popular bioinformatics tools to get inspired for this.

<img width="656" alt="Screenshot 2024-12-04 at 2 33 03 AM" src="https://github.com/user-attachments/assets/65a79130-b387-48fe-8aad-817c5fc635c1">


<img width="656" alt="Screenshot 2024-12-04 at 2 33 16 AM" src="https://github.com/user-attachments/assets/dccf2fda-f9d5-48b0-b78e-a7f359fcec43">


<img width="612" alt="Screenshot 2024-12-04 at 2 31 07 AM" src="https://github.com/user-attachments/assets/cfb19789-eea8-47a9-aabc-9e00f4108b97">


