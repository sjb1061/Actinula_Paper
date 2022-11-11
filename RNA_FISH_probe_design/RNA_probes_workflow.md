# RNA FISH Probe Design Workflow

This file is the step-by-step instructions for designing RNA Fluorescent in situ hybridization (FISH) probes for actinulae larvae (Hydrozoa) using Stellaris Custom RNA FISH Probe sets https://www.biosearchtech.com/products/rna-fish/custom-stellaris-probe-sets. I designed these probes based on the results of the gene expression work and outputs which will be refered to here. 

### Process overview: 
  1. Open the R output files for your gene sets of interest (generated at step 8 of the Transcriptome analysis) 
  2. Make a list of the OGs of insterest and their gene symbols and actinula sequence IDs
  3. Open the Rmd script - go through until you get the full actinula seq header with seq location - add to file  #go to line 146
  4. Use script to open salmon data and get expression values --> makes a csv
  5. Open csv and select the highest expressed headers for each OG
  6. Open alignment files for OGs of interest - blastp all seqs and compare to expression data - select best seqs
  7. Pull out all FASTA seqs, get exact seq (use snapgene) & blastx
  8. Choose best & make probes in stallaris 

### 1. Open R.md output file from step 8 of the transcriptome workflow
For each geneset of interest, open the the output file from the R.md script generated in step 8 of the transcriptome workflow:   
  - Sensory Perception of light stimulus: *8_Reduced_Ec_Sensory_Percep_Light_Stim_R_output_genes.txt*  
  - Sensory Perception of chemical stimulus: *8_Reduced_Ec_Sensory_Percep_Chem_Stim_R_output_genes.txt*  
  - Sensory Perceeption of mechanical stimulus: *8_Reduced_Ec_Sensory_Percep_Mechan_Stim_R_output_genes.txt*  
  
Each file contains the following information for all actinula sequences that are found in any of our annotated OGs for the cooresponding geneset:  gene_acc, Homo_seqid, OG, gene symbol, Actinula_seqid  

### 2. Make a list of the OGs of interest
Next, make a list of all OGs you are interested in making probes for   
  - Sensory Perception of light stimulus:  
    - RRH,OPN5,RHO,OPN4 OG0000063  
  
  - Sensory Perception of chemical stimulus: 
    - PKD1L3	OG0000024  
    - PKD2L1	OG0000899  

  - Sensory Perceeption of mechanical stimulus: 
    - PIEZO2	OG0001782  
    - TRPA1	OG0000887  


### 3. Get full sequence headers with sequence locations



### 4. Make a CSV of gene expression values for sequences of interest



### 5. Select the highest expressed actinula sequences for each OG 



### 6. Blastp highly expressed sequences 


### 7. Pull out FASTA sequences for all transcripts of interest and get exact sequence locaiton of transcript



### 8. Design probes in stellaris and order




