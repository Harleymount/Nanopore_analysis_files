#!/bin/bash
#analyze reads 


dir=$1;
file=$2
cd $dir;

python analyze_reads.py $file