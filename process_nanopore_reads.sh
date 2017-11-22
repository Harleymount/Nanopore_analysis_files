#!/bin/bash
#get command line options ----------------------------------------
for arg in "$@"; do
  shift
  case "$arg" in
    "--reference") set -- "$@" "-r" ;;
    "--spacer_bed") set -- "$@" "-x" ;;
	"--directory")   set -- "$@" "-z" ;;
    *)        set -- "$@" "$arg"
  esac
done


while getopts r:x:z: option
do
 case "${option}"
 in
 r) reference=${OPTARG};;
 x) spacer_bed=${OPTARG};;
 z) dir=$OPTARG;;
 esac
done

cd $dir;

#convert to fastq
ls | grep -E '\.fast5$'| parallel -j 0 'poretools fastq {} > {}.fastq' ;

find . -name '*.fast5' -print0 | xargs -0 rm;

gmap_build -d pLENS.genome $reference

ls | grep -E '\.fastq$' | parallel -j 0 'gmap -d pLENS.genome -A {} -f samse > {}.sam';

find . -name '*.fastq' -print0 | xargs -0 rm;

ls | grep -E '\.sam$' | parallel -j 0 'Picard SamFormatConverter I={} O={}.bam';
find . -name '*.sam' -print0 | xargs -0 rm;


ls | grep -E '\.bam$' | parallel -j 0 'Picard AddOrReplaceReadGroups I={} O={}_sorted.bam SORT_ORDER=coordinate RGLB=NA RGPL=Nanopore RGPU=NA RGSM=NA';
find . -name '*.sam.bam' -print0 | xargs -0 rm;



ls | grep -E '\_sorted.bam$' | parallel -j 0 'bedtools genomecov -d -split -ibam {} > {}.tdt';
find . -name '*_sorted.bam' -print0 | xargs -0 rm;


#now run my average coverage python script 
python average_coverage.py $dir

find . -name '*.tdt' -print0 | xargs -0 rm;



Rscript merge_csv.R $dir





