#### DESCRIPTION ####
# Explore the differences in the methylation calls between bismark (v0.8.1) with --new_flag option and without --new_flag option
# Peter Hickey (peter.hickey@gmail.com)
# 24/07/2013

##### Read in data ####
x <- list(new_flag_XM_filter = read.table('new_flag_filter=XM.wf', header = T, sep = '\t', stringsAsFactors = FALSE),
          new_flag_sequence_filter = read.table('new_flag_filter=sequence.wf', header = T, sep = '\t', stringsAsFactors = FALSE),
          new_flag_bismark_filter = read.table('new_flag_filter=bismark.wf', header = T, sep = '\t', stringsAsFactors = FALSE), 
          new_flag_no_filter = read.table('new_flag_filter=none.wf', header = T, sep = '\t', stringsAsFactors = FALSE),
          new_flag_bismark_methylation_extractor = read.table('CS_new_flag.SRR400564_1.fastq.gz_bismark_pe.bam.bedGraph', header = F, stringsAsFactors = FALSE, sep = '\t'),
          old_flag_bismark_methylation_extractor = read.table('CS_old_flag.SRR400564_1.fastq.gz_bismark_pe.bam.bedGraph', header = F, stringsAsFactors = FALSE, sep = '\t')
)

#### Dimension of the different methylation call sets ####
sapply(X = x, FUN = dim)

#### Comparison between new_flag_bismark_filter and old_flag_bismark_methylation_extractor ####
## Positions unique to one or the other
unique_positions <-  