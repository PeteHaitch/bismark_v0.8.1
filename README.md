bismark_v0.8.1
==============
Author: Peter Hickey (peter.hickey@gmail.com)

Branch of `bismark (v0.8.1)` to implement some of my ideas regarding `FLAG` values in `SAM/BAM` files. More specifically, to implement a proposed patch regarding how some of the strand and read orientation information is encoded in `SAM/BAM` files for paired-end data produced by Bismark and ensuring that other Bismark tools (such as `bismark_methylation_extractor`) can process these new file.

My motivation is for the suggested changes is because `SAM/BAMs` produced by Bismark don't always play nice with downstream tools for a few reasons:

1. __The `FLAG` in `SAM/BAMs` produced by Bismark mean paired-end read orientation is not compliant with `SAM` specifications.__ For example, `GATK` cannot correctly display paired-end data owing to the unique way Bismark encodes the bitwise `FLAG`. This is a problem for other downstream tools that rely on `FLAGs` for inferring the orientation of paired-end reads. I've included a screenshot from `IGV` of data PE data mapped using the Bismark defaults versus using the proposed patch. 
Bismark's `FLAG` encoding was a deliberate design choice because of the extra complications with stranded-ness for BS-seq data. However, even if Bismark uses these flags internally I think it should be possible to produce a `SAM/BAM` file that complies with `SAM` specifications (possibly in conjunction with the proposed `ZS` tag in 3).

2. __Appending of /1 and /2 to paired-end readnames.__ `Picard's MarkDuplicates` tool won't work by default when readnames are appended by /1 and /2 since they rely (in their default mode) on exact matching of readnames (it also won't work because of the FLAG issue). Similar problems occur when using some other `Picard` tools, such as when sorting `SAM/BAM` by queryname rather than coordinate using `Picard's SortSam` tool. Since the read_1/read_2 information can be encoded in the `FLAG` it shouldn't be necessary to also include it in the readnames. 

3.  __Appending strand information as it's own custom tag `ZS:Z:<tag>`, where `<tag> = OT, CTOT, OB or CTOB`.__ My understanding is that in Bismark that the `OT, CTOT, OB and CTOB` information is encoded in the `FLAG`. Could this information just be added as a custom tag, say `ZS` for "strand", like how `XR` and `XG` tags currently work? I suppose it's somewhat redundant since the `XR` and `XG` tags together allow you to infer the strand information. NB: Bowtie2 outputs its own tag called `XS` (as well as a `YS` tag), hence why I suggest `ZS`.

comethylation_v3.py is from https://github.com/PeteHaitch/Co-methylation based on commit 62f45088c57d75b23c152d3527db7ceeb8054384
