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
  ```
  qiime demux summarize \
  --i-data demux-paired-end.qza \
  --o-visualization demux.qzv
  ```    
  *secure copy the visualization to your desktop and drag file into qiime2 online visualizer:* https://view.qiime2.org  
  
### 2. Sequence quality control and feature table construction  
   At this step in the tutorial, there are 2 options for quality control methods to choose from, the DADA2 or the Deblur. I followed the Deblur quality control method.  

   A. Quality filter 
   ```
   qiime quality-filter q-score \
 --i-demux demux-paired-end.qza \
 --o-filtered-sequences demux-filtered.qza \
 --o-filter-stats demux-filter-stats.qza
 ```
 
 B. Truncate sequences
 ```
 qiime deblur denoise-16S \
  --i-demultiplexed-seqs demux-filtered.qza \
  --p-trim-length 251 \
  --o-representative-sequences rep-seqs-deblur.qza \
  --o-table table-deblur.qza \
  --p-sample-stats \
  --o-stats deblur-stats.qza
  ```
  
  C. Make Visualizations of part B stats and tabulate metadata
  
  ```
  qiime metadata tabulate \
  --m-input-file demux-filter-stats.qza \
  --o-visualization demux-filter-stats.qzv
  ```
  ```
  qiime deblur visualize-stats \
  --i-deblur-stats deblur-stats.qza \
  --o-visualization deblur-stats.qzv
  ``` 
  Rename files for next section: 
  `mv rep-seqs-deblur.qza rep-seqs.qza` 
  `mv table-deblur.qza table.qza`  
      
### 3. Feature Table and Feature Data Summaries  
```
qiime feature-table summarize \
  --i-table table.qza \
  --o-visualization table.qzv \
  --m-sample-metadata-file sample-metadata.tsv
  ```
  ```
  qiime feature-table tabulate-seqs \
  --i-data rep-seqs.qza \
  --o-visualization rep-seqs.qzv 
  ```
  
### Step 4: Generate a tree for phylogenetic diversity analysis 
```
qiime phylogeny align-to-tree-mafft-fasttree \
  --i-sequences rep-seqs.qza \
  --o-alignment aligned-rep-seqs.qza \
  --o-masked-alignment masked-aligned-rep-seqs.qza \
  --o-tree unrooted-tree.qza \
  --o-rooted-tree rooted-tree.qza
  ```
  ### Step 5: Alpha and beta diversity analysis 
  At this step we have to choose a sampling depth - we chose 2503 [we retain 12,515 (18.00%) features in 5 samples (100%)]   
  ```
  qiime diversity core-metrics-phylogenetic \
  --i-phylogeny rooted-tree.qza \
  --i-table table.qza \
  --p-sampling-depth 2503 \
  --m-metadata-file sample-metadata.tsv \
  --output-dir core-metrics-results 
  ```    
  
  ### Step 6: Taxonomic analysis
  First we need to download a classifier.  
  `wget \
  -O "gg-13-8-99-515-806-nb-classifier.qza" \
  "https://data.qiime2.org/2020.2/common/gg-13-8-99-515-806-nb-classifier.qza"`
  
  Assign taxonomy to the sequences
  ```     
  qiime feature-classifier classify-sklearn \
  --i-classifier gg-13-8-99-515-806-nb-classifier.qza \
  --i-reads rep-seqs.qza \
  --o-classification taxonomy.qza
  ```
  
  ```
  qiime metadata tabulate \
  --m-input-file taxonomy.qza \
  --o-visualization taxonomy.qzv
  ```
  View the taxonomic composition of ouru samples with interactive bar plots
  ```
  qiime taxa barplot \
  --i-table table.qza \
  --i-taxonomy taxonomy.qza \
  --m-metadata-file sample-metadata.tsv \
  --o-visualization taxa-bar-plots.qzv
  ```

  
  
