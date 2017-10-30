#!/bin/bash
#analyze reads 


dir=$1;
file=$2
cd $dir;

python analyze_reads.py $file;


Rscript plot_crossovers.R $dir discontinuous_hist.csv;
Rscript plot_losses.R $dir continuous_hist.csv;