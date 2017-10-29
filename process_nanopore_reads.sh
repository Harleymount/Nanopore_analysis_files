#!/bin/bash
dir=$1
spacer_bed=$2
reference=$3


cd $dir;

#convert to fastq
ls | grep -E '\.fast5$'| parallel -j 0 'poretools fastq {} > {}.fastq' ;

rm *.fast5;


ls | grep -E '\.fastq$' | parallel -j 0 'gmap -d pLENS.genome -A {} -f samse > {}.sam';

rm *.fastq;

ls | grep -E '\.sam$' | parallel 'Picard SamFormatConverter I={} O={}.bam';
rm *.sam;


ls | grep -E '\.bam$' | parallel 'Picard AddOrReplaceReadGroups I={} O={}_sorted.bam SORT_ORDER=coordinate RGLB=NA RGPL=Nanopore RGPU=NA RGSM=NA';
rm *.sam.bam;



ls | grep -E '\_sorted.bam$' | parallel 'bedtools genomecov -d -split -ibam {} > {}.tdt';
rm *_sorted.bam;


#now run my average coverage python script 
python average_coverage.py $dir

rm *.tdt



Rscript merge_csv.R $dir





