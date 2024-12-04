#!/usr/bin/env nextflow

nextflow.enable.dsl=2

params.reads_control = "./data/1000sub_control1.fastq"
params.reads_control2 = "./data/1000sub_control2.fastq"

params.reads_treatment = "./data/1000sub_treatment.fastq"
params.reads_treatment2 = "./data/1000sub_treatment2.fastq"

params.genome = './data/genome.fna'
params.gtf = './data/annotations.gtf'
params.star_index = './starindex'
params.output = './results'

process FASTQC {
    container 'quay.io/biocontainers/fastqc:0.12.1--hdfd78af_0'
    input:
    path reads_control
    path reads_control2
    path reads_treatment
    path reads_treatment2
    

    script:
    """
    fastqc -o . $reads_control $reads_control2 $reads_treatment $reads_treatment2
    """
}

process STARINDEX {
    container 'quay.io/biocontainers/star:2.7.11b--h43eeafb_3'
    input:
    path genome
    path gtf


    output:
    path params.star_index
    
    script:
    """
    STAR --runThreadN 4 --runMode genomeGenerate \\
         --genomeDir ${params.star_index} \\
         --genomeFastaFiles $genome \\
         --sjdbGTFfile $gtf \\
         --genomeSAindexNbases 12
       
    """
}


process STAR_ALIGN_CONTROL {
    container 'quay.io/biocontainers/star:2.7.11b--h43eeafb_3'
    input:
    path reads_control
    path star_index
    
    output:
    path 'controlReadsPerGene.out.tab'
    
    script:
    """
    STAR --runThreadN 4 --genomeDir $star_index \\
         --readFilesIn $reads_control \\
         --outSAMtype BAM SortedByCoordinate \\
         --quantMode GeneCounts \\
         --outFileNamePrefix control
    """
 
}

process STAR_ALIGN_CONTROL2 {
    container 'quay.io/biocontainers/star:2.7.11b--h43eeafb_3'
    input:
    path reads_control2
    path star_index
    
    output:
    path 'control2ReadsPerGene.out.tab'
    
    script:
    """
    STAR --runThreadN 4 --genomeDir $star_index \\
         --readFilesIn $reads_control2 \\
         --outSAMtype BAM SortedByCoordinate \\
         --quantMode GeneCounts \\
         --outFileNamePrefix control2
    """
 
}

process STAR_ALIGN_TREATMENT {
    container 'quay.io/biocontainers/star:2.7.11b--h43eeafb_3'
    input:
    path reads_treatment
    path star_index
    
    output:
    path 'treatmentReadsPerGene.out.tab'
    
    script:
    """
    STAR --runThreadN 4 --genomeDir $star_index \\
         --readFilesIn $reads_treatment \\
         --outSAMtype BAM SortedByCoordinate \\
         --quantMode GeneCounts \\
         --outFileNamePrefix treatment
    """
 
}

process STAR_ALIGN_TREATMENT2 {
    container 'quay.io/biocontainers/star:2.7.11b--h43eeafb_3'
    input:
    path reads_treatment2
    path star_index
    
    output:
    path 'treatment2ReadsPerGene.out.tab'
    
    script:
    """
    STAR --runThreadN 4 --genomeDir $star_index \\
         --readFilesIn $reads_treatment2 \\
         --outSAMtype BAM SortedByCoordinate \\
         --quantMode GeneCounts \\
         --outFileNamePrefix treatment2
    """
 
}

process GENE_METADATA_PROPORTIONS {
    input:
    path control_counts  

    
    
    output:
path "gene_metadata_proportions_with_percentages.png"
    
    script:
    """
    Rscript -e '
# Load the data
data <- read.delim("${control_counts}", header = TRUE)

# Extract only the metadata rows (first four rows)
metadata_rows <- data[1:4, 2:ncol(data)]  # Skip the first column (gene_id)

# Compute the sum of each category across all samples
metadata_sums <- rowSums(metadata_rows)

# Define labels with category names
labels <- c("N_unmapped", "N_multimapping", "N_noFeature", "N_ambiguous")

# Plot the pie chart with labels
png("gene_metadata_proportions_with_percentages.png", width = 800, height = 600)
pie(metadata_sums, labels = labels, 
    main = "Proportion of Reads in Metadata Categories", 
    col = rainbow(length(metadata_sums)))
    '
    """
}  


workflow {
    control_ch = Channel.fromPath(params.reads_control)
    control2_ch = Channel.fromPath(params.reads_control2)
    treatment_ch = Channel.fromPath(params.reads_treatment)
    treatment2_ch = Channel.fromPath(params.reads_treatment2)
    
    FASTQC(control_ch, control2_ch, treatment_ch, treatment2_ch)
    
    genome_ch = Channel.fromPath(params.genome)
    gtf_ch = Channel.fromPath(params.gtf)
    
    star_index = STARINDEX(genome_ch, gtf_ch)
    
    control_counts_ch = STAR_ALIGN_CONTROL(control_ch, star_index)
    STAR_ALIGN_CONTROL2(control2_ch, star_index)
    STAR_ALIGN_TREATMENT(treatment_ch, star_index)
    STAR_ALIGN_TREATMENT2(treatment2_ch, star_index)

    
    
    GENE_METADATA_PROPORTIONS(STAR_ALIGN_CONTROL.out)
}
