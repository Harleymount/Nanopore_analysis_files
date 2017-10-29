args = commandArgs(trailingOnly=TRUE)
dir=args[1]
files <- list.files(path=dir, pattern="*.csv", full.names=T, recursive=FALSE)
files<-head(files, -1)

length_dataframe=read.csv(files[1], header=F)


column_name<-paste(unlist(strsplit(files[1], '_'))[grep('ch', unlist(strsplit(files[1], '_')))], unlist(strsplit(files[1], '_'))[grep('read', unlist(strsplit(files[1], '_')))], sep="_")
colnames(length_dataframe)<-c('spacer',column_name)

for (i in tail(files,-1)){
    new_data=read.csv(i, header=F)
    column_name<-paste(unlist(strsplit(i, '_'))[grep('ch', unlist(strsplit(i, '_')))], unlist(strsplit(i, '_'))[grep('read', unlist(strsplit(i, '_')))], sep="_")
    length_dataframe<-cbind(length_dataframe, new_data$V2)
    colnames(length_dataframe)[which(names(length_dataframe) == 'new_data$V2')]<-column_name}

write.csv(length_dataframe, "Matrix_output.csv")



