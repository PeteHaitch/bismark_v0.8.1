#### DESCRIPTION ####
# Workflow for testing my modifications to bismark (v0.8.1_PH). To be run in folder containing my modified version of bismark (v0.8.1_PH)
# Peter Hickey (peter.hickey@gmail.com)
# 24/07/2013

#### Environment variables ####
TMP_DIR=/usr/local/work/hickey/

#### Download SRA data and extract as gzipped FASTQ files ####
mkdir test_data

cd test_data

wget http://ftp-trace.ncbi.nlm.nih.gov/sra/sra-instant/reads/ByRun/sra/SRR/SRR400/SRR400564/SRR400564.sra

fastq-dump --gzip --split-files SRR400564.sra

#### Align data both with and without the --new_flag option ####
cd ..

./bismark --bam --new_flag --prefix new_flag /home/users/lab0605/hickey/WGBS/aligner_indexes/Bismark_Bowtie1/hg19+lambda_phage/Bismark_Bowtie1_hg19+lambda_phage.genome_folder/ -1 test_data/SRR400564_1.fastq.gz -2 test_data/SRR400564_2.fastq.gz -o test_data/

./bismark --bam --prefix old_flag /home/users/lab0605/hickey/WGBS/aligner_indexes/Bismark_Bowtie1/hg19+lambda_phage/Bismark_Bowtie1_hg19+lambda_phage.genome_folder/ -1 test_data/SRR400564_1.fastq.gz -2 test_data/SRR400564_2.fastq.gz -o test_data/

#### Sort BAM files by coordinate and index the sorted BAMs ####
cd test_data

SortSam I=new_flag.SRR400564_1.fastq.gz_bismark_pe.bam O=CS_new_flag.SRR400564_1.fastq.gz_bismark_pe.bam SO=coordinate TMP_DIR=${TMP_DIR}

SortSam I=old_flag.SRR400564_1.fastq.gz_bismark_pe.bam O=CS_old_flag.SRR400564_1.fastq.gz_bismark_pe.bam SO=coordinate TMP_DIR=${TMP_DIR}

samtools index CS_new_flag.SRR400564_1.fastq.gz_bismark_pe.bam

samtools index CS_new_flag.SRR400564_1.fastq.gz_bismark_pe.bam

#### Sort "new_flag" BAM by queryname ####
SortSam I=new_flag.SRR400564_1.fastq.gz_bismark_pe.bam O=QS_new_flag.SRR400564_1.fastq.gz_bismark_pe.bam SO=queryname TMP_DIR=${TMP_DIR}

#### Run comethylation_v3.py on QS_new_flag.SRR400564_1.fastq.gz_bismark_pe.bam with different filters on overlapping mates from paired-end reads ####
mkdir test_data/log

python comethylation_v3.py --nTuple 1 --methylationType CG --overlappingPairedEndCheck bismark test_data/QS_new_flag.SRR400564_1.fastq.gz_bismark_pe.bam test_data/new_flag_filter=bismark &> test_data/log/new_flag_filter=bismark.log

python comethylation_v3.py --nTuple 1 --methylationType CG --overlappingPairedEndCheck sequence test_data/QS_new_flag.SRR400564_1.fastq.gz_bismark_pe.bam test_data/new_flag_filter=sequence &> test_data/log/new_flag_filter=sequence.log

python comethylation_v3.py --nTuple 1 --methylationType CG --overlappingPairedEndCheck XM test_data/QS_new_flag.SRR400564_1.fastq.gz_bismark_pe.bam test_data/new_flag_filter=XM &> test_data/log/new_flag_filter=XM.log

python comethylation_v3.py --nTuple 1 --methylationType CG --overlappingPairedEndCheck none test_data/QS_new_flag.SRR400564_1.fastq.gz_bismark_pe.bam test_data/new_flag_filter=none &> test_data/log/new_flag_filter=none.log

#### Run bismark_methylation_extractor and bismark2bedGraph on CS_new_flag.SRR400564_1.fastq.gz_bismark_pe.bam and CS_old_flag.SRR400564_1.fastq.gz_bismark_pe.bam (have to manually invoke bismark2bedGraph since it is not in my $PATH ####
perl bismark2bedGraph --o CS_new_flag.SRR400564_1.fastq.gz_bismark_pe.bam.bedGraph --dir test_data/ --counts --buffer_size 20G test_data/CpG_*_new*

perl bismark2bedGraph --o CS_old_flag.SRR400564_1.fastq.gz_bismark_pe.bam.bedGraph --dir test_data/ --counts --buffer_size 20G test_data/CpG_*_old*

#### Explore results in R (see test_data/explore_methylation_calling.r) ####