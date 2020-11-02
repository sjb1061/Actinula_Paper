# Step by Step Methods of Biofilm Analysis 
   This file is the step by step instructions of our Biofilm analysis. This file contains the code we ran in this analysis, for additional information please look up the Moving Pictures tutorial https://docs.qiime2.org/2020.6/tutorials/moving-pictures/. Our goal was to identify the taxonomic composition of the 5 biofilm samples collected during the larval settlement study in June 2020.  
   
### 1. Import data by creating a QIIME artifact 
The first step of this analysis is to activate the qiime environment and to import our data. For importing our data, follow: Casava 1.8 paired-end demultiplexed fastq   

   Activate the current qiime2 enviornement (QIIME2 2020.2):   
   `module load anaconda/colsa`     
   `conda activate qiime2-2020.2`   
   
   Import data: 
   ```
   qiime tools import \
  --type 'SampleData[PairedEndSequencesWithQuality]' \
  --input-path ../reads \
  --input-format CasavaOneEightSingleLanePerSampleDirFmt \
  --output-path demux-paired-end.qza
  ```    
  
  Output Artifact: demux-paired-end.qza   
  
  Visualize output:
  ```qiime demux summarize \
  --i-data demux-paired-end.qza \
  --o-visualization demux.qzv
  ```    
  *secure copy the visualization to your desktop and drag file into qiime2 online visualizer:* https://view.qiime2.org  
  
  
