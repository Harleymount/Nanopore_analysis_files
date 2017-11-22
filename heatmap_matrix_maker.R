#this code will be used to make the fine tuned heatmaps that shayna wants



#discontinuous matrix has two and above losses 
#continuous matrix has only one loss 

args = commandArgs(trailingOnly=TRUE)
raw_matrix=args[1]
disco=args[2]
cont=args[3]

#==============Load files based on user input=====================
raw_matrix<-read.csv(raw_matrix)
disco<-read.csv(disco)
cont<-read.csv(cont)


##-----------------load matrices  DEBUGGING
#disco<-read.csv('discontinuous_hist.csv')
#raw_matrix<-read.csv('matrix_output.csv')
#cont<-read.csv('continuous_hist.csv')
#----------------------------------

#-----------------clean up raw matrix
raw_matrix$X<-NULL
#---------------------------------------

#==================write a code to take read names only for disco reads with > 1 
disco_greater_than_one<-subset(disco, disco$crossovers > 1)



#take out the read names for those reads with greater than 1 crossover 
read_names_disco<-as.character(disco_greater_than_one$read_name)
#also add the spacer column to this subsetted matrix 
read_names_disco<-c(read_names_disco, 'spacer')



#--------------------------getting reads with continuous crossovers
#take reads with only one crossover 
cont_read_names<-as.character(cont$read_name)
#add the spacer column to this subsetted matrix
cont_read_names<-c(cont_read_names, 'spacer')
#=============subet the raw output matrix for the reads we identified above (continuous, or discontinuous)

#subset raw matrix for discontinuous reads 
disco_matrix<-raw_matrix[,c(read_names_disco)]
#subset matrix for continuous reads
cont_matrix<-raw_matrix[,c(cont_read_names)]
#------------write to output for plotting as a heatmap
write.csv(disco_matrix,'discontinous_matrix.csv')
write.csv(cont_matrix, 'continuous_matrix.csv')
