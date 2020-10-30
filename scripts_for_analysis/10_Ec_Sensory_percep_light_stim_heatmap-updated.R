library(tximport); library(readr); library(edgeR)

setwd("~/Desktop/R /Transcriptomics_Actinula_3-17-20")
system('ls')

dir <- getwd()
list.files()

#6 groups - Full Gene Set

#library info file
devstages<-read.table("libraries_to_stages.txt",header=F,row.names=1)
dev1<-rownames(devstages)[which(devstages$V2==1)]; dev1files <- file.path(dir, "mapping",dev1, "quant.sf"); names(dev1files)<-dev1
dev2 <-rownames(devstages)[which(devstages$V2==2)]; dev2files <- file.path(dir, "mapping",dev2, "quant.sf"); names(dev2files)<-dev2
dev3 <-rownames(devstages)[which(devstages$V2==3)]; dev3files <- file.path(dir, "mapping",dev3, "quant.sf"); names(dev3files)<-dev3
dev4 <-rownames(devstages)[which(devstages$V2==4)]; dev4files <- file.path(dir, "mapping",dev4, "quant.sf"); names(dev4files)<-dev4
dev5<-rownames(devstages)[which(devstages$V2==5)]; dev5files <- file.path(dir, "mapping",dev5, "quant.sf"); names(dev5files)<-dev5
dev6 <-rownames(devstages)[which(devstages$V2==6)]; dev6files <- file.path(dir, "mapping",dev6, "quant.sf"); names(dev6files)<-dev6

txi.salmon<- tximport(c(dev1files,dev2files,dev3files,dev4files,dev5files,dev6files), type = "salmon", txOut=T)
cts <- txi.salmon$counts
head(cts)
b<-DGEList(counts=cts, group=c(1,1,1,1,1,1,2,2,2,2,2,2,3,3,3,3,3,3,4,4,4,4,4,4,5,5,5,5,5,5,6,6,6,6,6,6))
normcounts<-cpm(b, normalized.lib.sizes=T) #normalized library counts for all genes


#set up geneID map (hashtable, dictionary, lookup, etc) 
#homohydra.map<-hydract_acc_apo_OGs_acc_sym #use if inital with other r script
#homohydra.map<- read.table("Hs_Sensory_percep_light_stim_R_output_genes.txt",header=T, stringsAsFactors=F) #Full
homohydra.map<- read.table("Reduced_Ec_Sensory_Percep_Light_Stim_R_output_genes.txt",header=T, stringsAsFactors=F) #Reduced

str(homohydra.map) #should be data frame
length(homohydra.map) #5 col with 619 enteries

#import collapsed symbols for OG - add to dataset
all_symbols_for_OGs <- read.delim("~/Desktop/R /Transcriptomics_Actinula_3-17-20/DEGs_p0.05_6groups/Reduced R output genes from geneset and symbols/sens_percep_light-all_symbols_for_OGs.txt") #Reduced
names(all_symbols_for_OGs)[2] <- c("tot_symbol")
str(all_symbols_for_OGs)
all_symbols_for_OGs$OG<- as.character(all_symbols_for_OGs$OG)
all_symbols_for_OGs$tot_symbol<- as.character(all_symbols_for_OGs$tot_symbol)
str(all_symbols_for_OGs)

nrow(homohydra.map)
homohydra.map<-inner_join(homohydra.map[,1:5],all_symbols_for_OGs,by="OG")
str(homohydra.map)

#make new column for naming the transcripts
library(tidyr)
homohydra.map <-unite(homohydra.map, symbol_seqid, tot_symbol:Actinula_seqid, sep= "    ", remove=F, na.rm=FALSE )
head(homohydra.map)

#Keep only unique hydractinia headers
#library(dplyr)
length(homohydra.map$Actinula_seqid)
length(unique(homohydra.map$Actinula_seqid))

homohydra.map<- homohydra.map[!duplicated(homohydra.map$Actinula_seqid), ]
length(homohydra.map$Actinula_seqid)

keep<-unique(homohydra.map$Actinula_seqid); length(keep) #1 col with 32 enteries 


#select just TF genes
TFcts <-normcounts[keep,]
nrow(TFcts) #25
sort(homohydra.map$symbol)  #doublecheck that IDs are correctly sampled - should be gene symbol #25 
sort(rownames(TFcts)) #25

#construct heatmap of genes in map across devs
#using row as color break 
rgb.palette <- colorRampPalette(c( "red","black","green"),space = "Lab")
#specifying color break 
rgb.palette2 <- colorRampPalette(c( "red","black","green"))(n=299) #,space = "Lab"
col_breaks = c(seq(0,33,length=100), seq(33.01,66,length=100), seq(66.01,100,length=100))
#summary(TFcts) #to figure out range

library(gplots)

#pdf("BestTFhits all and averaged.pdf",height=11,width=8)  
#using row as color break (normal)
heatmap.2(TFcts,  scale="row", labRow = homohydra.map$symbol_seqid,    Colv=F,  trace="none",  dendrogram="row",  key=F,  col=rgb.palette(120),  density.info=NULL,  margins=c(5, 11),  lmat=rbind(4:3, 2:1),  lhei=c(1, 30),  lwid=c(1, 1),cexRow = 0.80);
#                                       change to symbol col  	
#specifying color break
heatmap.2(TFcts,  scale="none", labRow = homohydra.map$symbol_seqid,    Colv=F,  trace="none",  dendrogram="row",  key=F,  col=rgb.palette2, breaks=col_breaks, density.info=NULL,  margins=c(5, 11),  lmat=rbind(4:3, 2:1),  lhei=c(1, 30),  lwid=c(1, 1),cexRow = 0.80);


# take average (normalized) counts for each dev stage
tcts<-t(TFcts); dev<-factor(c(1,1,1,1,1,1,2,2,2,2,2,2,3,3,3,3,3,3,4,4,4,4,4,4,5,5,5,5,5,5,6,6,6,6,6,6));dat<-cbind(dev, tcts)
dev.means<-by(dat, dev, function(x) colMeans(x[, -1]))
dev.means2<-as.data.frame(t(sapply(dev.means, I)))

#heatmaps using row as color break (normal)
#heatmap.2(t(dev.means2), labRow = homohydra.map$symbol, scale="row", Colv=F, trace="none", dendrogram="row", key=F, col=rgb.palette(120), density.info=NULL,  margins=c(3, 10),  lmat=rbind(4:3, 2:1),  lhei=c(1, 30),  lwid=c(1, 1));
#heatmap.2(t(dev.means2), labRow = homohydra.map$Hydractinia_seqid, scale="row", Colv=F, trace="none", dendrogram="row", key=F, col=rgb.palette(120), density.info=NULL,  margins=c(3, 10),  lmat=rbind(4:3, 2:1),  lhei=c(1, 30),  lwid=c(1, 1));
heatmap.2(t(dev.means2), labRow = homohydra.map$symbol_seqid, scale="row", Colv=F, trace="none", dendrogram="row", key=F, col=rgb.palette(120), density.info=NULL,  margins=c(2.5, 10.75),  lmat=rbind(4:3, 2:1),  lhei=c(1, 30),  lwid=c(1, 1), cexRow = 0.80);
heatmap.2(t(dev.means2), cellnote= round(t(dev.means2), digits = 3), notecol = "white", labRow = homohydra.map$symbol_seqid, scale="row", Colv=F, trace="none", dendrogram="row", key=F, col=rgb.palette(120), density.info=NULL,  margins=c(2.5, 10.75),  lmat=rbind(4:3, 2:1),  lhei=c(1, 30),  lwid=c(1, 1), cexRow = 0.80);

#heatmaps specifiying color break
heatmap.2(t(dev.means2), labRow = homohydra.map$symbol_seqid, scale="none", Colv=F, trace="none", dendrogram="row", key=F, col=rgb.palette2, breaks=col_breaks, density.info=NULL,  margins=c(2.5, 10.75),  lmat=rbind(4:3, 2:1),  lhei=c(1, 30),  lwid=c(1, 1), cexRow = 0.80);
#round(t(dev.means2), digits = 3) #round numbers in heatmap
heatmap.2(t(dev.means2), cellnote= round(t(dev.means2), digits = 3), notecol = "white", notecex = 1 , labRow = homohydra.map$symbol_seqid, scale="none", Colv=F, trace="none", dendrogram="row", key=F, col=rgb.palette2, breaks=col_breaks, density.info=NULL,  margins=c(3,11),  lmat=rbind(4:3, 2:1),  lhei=c(1, 30),  lwid=c(1, 1), cexRow = 0.80);






##### Clear objects from workspace #####



##Sig DEG Heatmaps for 6 groups

library(tximport); library(readr); library(edgeR)

setwd("~/Desktop/R /Transcriptomics_Actinula_3-17-20")
system('ls')

dir <- getwd()
list.files()

#6 groups - Sig DEGs from Gene Set

#library info file
devstages<-read.table("libraries_to_stages.txt",header=F,row.names=1)
dev1<-rownames(devstages)[which(devstages$V2==1)]; dev1files <- file.path(dir, "mapping",dev1, "quant.sf"); names(dev1files)<-dev1
dev2 <-rownames(devstages)[which(devstages$V2==2)]; dev2files <- file.path(dir, "mapping",dev2, "quant.sf"); names(dev2files)<-dev2
dev3 <-rownames(devstages)[which(devstages$V2==3)]; dev3files <- file.path(dir, "mapping",dev3, "quant.sf"); names(dev3files)<-dev3
dev4 <-rownames(devstages)[which(devstages$V2==4)]; dev4files <- file.path(dir, "mapping",dev4, "quant.sf"); names(dev4files)<-dev4
dev5<-rownames(devstages)[which(devstages$V2==5)]; dev5files <- file.path(dir, "mapping",dev5, "quant.sf"); names(dev5files)<-dev5
dev6 <-rownames(devstages)[which(devstages$V2==6)]; dev6files <- file.path(dir, "mapping",dev6, "quant.sf"); names(dev6files)<-dev6

txi.salmon<- tximport(c(dev1files,dev2files,dev3files,dev4files,dev5files,dev6files), type = "salmon", txOut=T)
cts <- txi.salmon$counts
head(cts)
b<-DGEList(counts=cts, group=c(1,1,1,1,1,1,2,2,2,2,2,2,3,3,3,3,3,3,4,4,4,4,4,4,5,5,5,5,5,5,6,6,6,6,6,6))
normcounts<-cpm(b, normalized.lib.sizes=T) #normalized l

#make a matrix of significant degs from this data set - run prep_sig_DEGs_for_heatmap.py in terminal to get sig degs formated in this way
#REDUCED
sig_degs<-c("Ec_actinula_t.97429","Ec_actinula_t.83196","Ec_actinula_t.66600","Ec_actinula_t.67621","Ec_actinula_t.66245","Ec_actinula_t.52088","Ec_actinula_t.97444","Ec_actinula_t.66600","Ec_actinula_t.65838","Ec_actinula_t.52088","Ec_actinula_t.53746","Ec_actinula_t.97444","Ec_actinula_t.96544","Ec_actinula_t.94044","Ec_actinula_t.52283","Ec_actinula_t.67621","Ec_actinula_t.68284","Ec_actinula_t.83034","Ec_actinula_t.53522","Ec_actinula_t.102475","Ec_actinula_t.83179","Ec_actinula_t.97443","Ec_actinula_t.97444","Ec_actinula_t.66600","Ec_actinula_t.53144","Ec_actinula_t.65960","Ec_actinula_t.69692","Ec_actinula_t.53746","Ec_actinula_t.97444","Ec_actinula_t.96544","Ec_actinula_t.66600","Ec_actinula_t.91272","Ec_actinula_t.52283","Ec_actinula_t.52283") #Reduced 


#make into a data frame and change name of column 
sig_degs_df<-data.frame(sig_degs)
str(sig_degs_df)
names(sig_degs_df)[1] <- c("Actinula_seqid")

#make data characters not factor so they can be compared
sig_degs_df$Actinula_seqid<- as.character(sig_degs_df$Actinula_seqid)
str(sig_degs_df)

#homohydra.map<- read.table("Hs_detect_light_stim_genes_R_output.txt",header=T, stringsAsFactors=F) #Full
homohydra.map<- read.table("Reduced_Ec_Sensory_Percep_Light_Stim_R_output_genes.txt",header=T, stringsAsFactors=F) #Reduced
str(homohydra.map) #should be data frame

#import collapsed symbols for OG - add to dataset
all_symbols_for_OGs <- read.delim("~/Desktop/R /Transcriptomics_Actinula_3-17-20/DEGs_p0.05_6groups/Reduced R output genes from geneset and symbols/sens_percep_light-all_symbols_for_OGs.txt")
names(all_symbols_for_OGs)[2] <- c("tot_symbol")
str(all_symbols_for_OGs)
all_symbols_for_OGs$OG<- as.character(all_symbols_for_OGs$OG)
all_symbols_for_OGs$tot_symbol<- as.character(all_symbols_for_OGs$tot_symbol)
str(all_symbols_for_OGs)

nrow(homohydra.map)
homohydra.map<-inner_join(homohydra.map[,1:5],all_symbols_for_OGs,by="OG")
str(homohydra.map)

#make new column for naming the transcripts
library(tidyr)
homohydra.map <-unite(homohydra.map, symbol_seqid, tot_symbol:Actinula_seqid, sep= "    ", remove=F, na.rm=FALSE )

library(dplyr)
#join sig degs to homohydra.map
str(homohydra.map)
sig_set<-inner_join(homohydra.map[,1:7],sig_degs_df,by="Actinula_seqid")
nrow(sig_set)
length(unique(sig_set$Actinula_seqid))

#Keep only unique hydractinia headers
#library(dplyr)
unique_sig_set<- sig_set[!duplicated(sig_set$Actinula_seqid), ]
length(unique_sig_set$Actinula_seqid)

homohydra.map<-unique_sig_set
keep<-unique(homohydra.map$Actinula_seqid); length(keep) #1 col with 32 enteries 


#select just TF genes
TFcts <-normcounts[keep,]
nrow(TFcts) #25
sort(homohydra.map$symbol)  #doublecheck that IDs are correctly sampled - should be gene symbol #25 
sort(rownames(TFcts)) #25

#construct heatmap of genes in map across devs
#using row as color break 
rgb.palette <- colorRampPalette(c( "red","black","green"),space = "Lab")
#specifying color break 
rgb.palette2 <- colorRampPalette(c( "red","black","green"))(n=299) #,space = "Lab"
col_breaks = c(seq(0,33,length=100), seq(33.01,66,length=100), seq(66.01,100,length=100))

library(gplots)

#pdf("BestTFhits all and averaged.pdf",height=11,width=8)  
#using row as color break
heatmap.2(TFcts,  scale="row", labRow = homohydra.map$symbol_seqid,    Colv=F,  trace="none",  dendrogram="row",  key=F,  col=rgb.palette(120),  density.info=NULL,  margins=c(5, 11),  lmat=rbind(4:3, 2:1),  lhei=c(1, 30),  lwid=c(1, 1),cexRow = 0.80);
#                                       change to symbol col  	
#specifying color break
heatmap.2(TFcts,  scale="none", labRow = homohydra.map$symbol_seqid,    Colv=F,  trace="none",  dendrogram="row",  key=F,  col=rgb.palette2, breaks=col_breaks, density.info=NULL,  margins=c(5, 11),  lmat=rbind(4:3, 2:1),  lhei=c(1, 30),  lwid=c(1, 1),cexRow = 0.80);


# take average (normalized) counts for each dev stage
tcts<-t(TFcts); dev<-factor(c(1,1,1,1,1,1,2,2,2,2,2,2,3,3,3,3,3,3,4,4,4,4,4,4,5,5,5,5,5,5,6,6,6,6,6,6));dat<-cbind(dev, tcts)
dev.means<-by(dat, dev, function(x) colMeans(x[, -1]))
dev.means2<-as.data.frame(t(sapply(dev.means, I)))

#heatmaps using row as color break
#heatmap.2(t(dev.means2), labRow = homohydra.map$symbol, scale="row", Colv=F, trace="none", dendrogram="row", key=F, col=rgb.palette(120), density.info=NULL,  margins=c(3, 10),  lmat=rbind(4:3, 2:1),  lhei=c(1, 30),  lwid=c(1, 1));
#heatmap.2(t(dev.means2), labRow = homohydra.map$Hydractinia_seqid, scale="row", Colv=F, trace="none", dendrogram="row", key=F, col=rgb.palette(120), density.info=NULL,  margins=c(3, 10),  lmat=rbind(4:3, 2:1),  lhei=c(1, 30),  lwid=c(1, 1));
heatmap.2(t(dev.means2), labRow = homohydra.map$symbol_seqid, scale="row", Colv=F, trace="none", dendrogram="row", key=F, col=rgb.palette(120), density.info=NULL,  margins=c(2.5, 10.75),  lmat=rbind(4:3, 2:1),  lhei=c(1, 30),  lwid=c(1, 1), cexRow = 0.80);
heatmap.2(t(dev.means2), cellnote= round(t(dev.means2), digits = 3), notecol = "white", labRow = homohydra.map$symbol_seqid, scale="row", Colv=F, trace="none", dendrogram="row", key=F, col=rgb.palette(120), density.info=NULL,  margins=c(2.5, 10.75),  lmat=rbind(4:3, 2:1),  lhei=c(1, 30),  lwid=c(1, 1), cexRow = 0.80);

#heatmaps specifiying color break
heatmap.2(t(dev.means2), labRow = homohydra.map$symbol_seqid, scale="none", Colv=F, trace="none", dendrogram="row", key=F, col=rgb.palette2, breaks=col_breaks, density.info=NULL,  margins=c(2.5, 10.75),  lmat=rbind(4:3, 2:1),  lhei=c(1, 30),  lwid=c(1, 1), cexRow = 0.80);
heatmap.2(t(dev.means2), cellnote= round(t(dev.means2), digits = 3), notecol = "white", labRow = homohydra.map$symbol_seqid, scale="none", Colv=F, trace="none", dendrogram="row", key=F, col=rgb.palette2, breaks=col_breaks, density.info=NULL,  margins=c(3,11),  lmat=rbind(4:3, 2:1),  lhei=c(1, 30),  lwid=c(1, 1), cexRow = 0.80);


