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

rm *.fast5;

gmap_build -d pLENS.genome $reference

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





