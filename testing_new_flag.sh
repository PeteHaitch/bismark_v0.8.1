#### DESCRIPTION ####
# Workflow for testing my modifications to bismark (v0.8.1_PH). 
# To be run in folder containing my modified version of bismark (v0.8.1_PH)
# Peter Hickey (peter.hickey@gmail.com)
# 25/07/2013

#### Download SRA data SRR400564 and extract as gzipped FASTQ files ####
mkdir old_flag
mkdir new_flag
mkdir SRR400564

cd SRR400564

wget http://ftp-trace.ncbi.nlm.nih.gov/sra/sra-instant/reads/ByRun/sra/SRR/SRR400/SRR400564/SRR400564.sra 

fastq-dump --gzip --split-files SRR400564.sra

#### Align data both with and without the --new_flag option ####
cd ..

./bismark --bam --new_flag --prefix new_flag /home/users/lab0605/hickey/WGBS/aligner_indexes/Bismark_Bowtie1/hg19+lambda_phage/Bismark_Bowtie1_hg19+lambda_phage.genome_folder/ -1 SRR400564/SRR400564_1.fastq.gz -2 SRR400564/SRR400564_2.fastq.gz -o new_flag/

./bismark --bam --prefix old_flag /home/users/lab0605/hickey/WGBS/aligner_indexes/Bismark_Bowtie1/hg19+lambda_phage/Bismark_Bowtie1_hg19+lambda_phage.genome_folder/ -1 SRR400564/SRR400564_1.fastq.gz -2 SRR400564/SRR400564_2.fastq.gz -o old_flag/

#### Run bismark_methylation_extractor on new_flag.SRR400564_1.fastq.gz_bismark_pe.bam and old_flag.SRR400564_1.fastq.gz_bismark_pe.bam ####
./bismark_methylation_extractor -p --no_overlap --ignore 2 --ignore_r2 7 -o old_flag --bedGraph --counts old_flag/old_flag.SRR400564_1.fastq.gz_bismark_pe.bam

./bismark_methylation_extractor -p --no_overlap --ignore 2 --ignore_r2 7 -o new_flag --bedGraph --counts new_flag/new_flag.SRR400564_1.fastq.gz_bismark_pe.bam

#### Check for differences between new_flag and old_flag files, e.g. using diff ####

