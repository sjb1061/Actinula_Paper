# RNA FISH Probe Design Workflow

This file is the step-by-step instructions for designing RNA Fluorescent in situ hybridization (FISH) probes for actinulae larvae (Hydrozoa) using Stellaris Custom RNA FISH Probe sets https://www.biosearchtech.com/products/rna-fish/custom-stellaris-probe-sets. I designed these probes based on the results of the gene expression work and outputs which will be refered to here. Scripts for this section can be found in the directory: Actinula_Paper/RNA_FISH_probe_design/Probe_design_scripts 

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
  A. Open the Rmd scripts for the genesets of interest and go through the script until line 146.  
  B. Open the actinula_acc_apo_OGs_acc_sym dataframe and search the OG of interest  
  C. For each OG, write out the full actinula sequence header which contains the sequence location - we will need that later in Step 7.  

  - Sensory Perception of light stimulus:  
     - Ec_actinula_t.28006..356-39	RRH,OPN5,RHO,OPN4	OG0000063
     - Ec_actinula_t.72976..146-1048	RRH,OPN5,RHO,OPN4	OG0000063
     - Ec_actinula_t.97788..1291-986	RRH,OPN5,RHO,OPN4	OG0000063
     - Ec_actinula_t.97788..970-584	RRH,OPN5,RHO,OPN4	OG0000063 
  
  - Sensory Perception of chemical stimulus: 
     - Ec_actinula_t.100430..3134-5638	PKD1L3	OG0000024
     - Ec_actinula_t.100430..6459-9845	PKD1L3	OG0000024
     - Ec_actinula_t.103146..3-2969	PKD1L3	OG0000024
     - Ec_actinula_t.1124..593-237	PKD1L3	OG0000024
     - Ec_actinula_t.33359..1-705	PKD1L3	OG0000024
     - Ec_actinula_t.637..3846-322	PKD1L3	OG0000024
     - Ec_actinula_t.66208..2940-1282	PKD1L3	OG0000024
     - Ec_actinula_t.66208..4060-2882	PKD1L3	OG0000024
     - Ec_actinula_t.90542..2-2404	PKD1L3	OG0000024
     - Ec_actinula_t.90542..2196-2618	PKD1L3	OG0000024

    
     - Ec_actinula_t.17768..3508-1277	PKD2L1	OG0000899
     - Ec_actinula_t.27738..1-2184	PKD2L1	OG0000899
     - Ec_actinula_t.37685..108-947	PKD2L1	OG0000899
     - Ec_actinula_t.50415..1309-167	PKD2L1	OG0000899
     - Ec_actinula_t.50416..1024-557	PKD2L1	OG0000899
     - Ec_actinula_t.81080..203-2761	PKD2L1	OG0000899
     - Ec_actinula_t.82249..123-2579	PKD2L1	OG0000899 

  - Sensory Perceeption of mechanical stimulus: 
     - Ec_actinula_t.17544..7629-1057	PIEZO2	OG0001782
     - Ec_actinula_t.46001..442-2	PIEZO2	OG0001782

     - Ec_actinula_t.66269..63-3458	TRPA1	OG0000887
     - Ec_actinula_t.84956..107-3508	TRPA1	OG0000887

### 4. Make a CSV of gene expression values for sequences of interest
In the terminal, make a probes directory where you can easily navigate to your salmon dir from the transcriptome analysis.    
  `mkdir ectopleura_transcriptomics/ectopleura_probes`  
  
Next, in the ectopleura_probes dir, make dirs for each of your OGs of interest:   
  `mkdir ectopleura_transcriptomics/ectopleura_probes/opsins`  
  `mkdir ectopleura_transcriptomics/ectopleura_probes/PKD1L3`  
  `mkdir ectopleura_transcriptomics/ectopleura_probes/PKD2L1`  
  `mkdir ectopleura_transcriptomics/ectopleura_probes/piezo`  
  `mkdir ectopleura_transcriptomics/ectopleura_probes/TRP`  
  
In each dir, make a headers of interest file and copy the information we listed out in Step 3. Each line should contain the following information in order for however many headers you have in each OG: complete header (described in the above step), the gene symbol, and OG. (Each item should be tab seperated) 

`nano opsin_headers_of_interest_OG0000063`  
`nano piezo_headers_of_interest_OG0001782`  
`nano TRP_headers_of_interest_OG0000887`  
`nano PKD1L3_headers_of_interest_OG0000024`  
`nano PKD2L1_headers_of_interest_OG0000899`  


### 5. Select the highest expressed actinula sequences for each OG 



### 6. Blastp highly expressed sequences 


### 7. Pull out FASTA sequences for all transcripts of interest and get exact sequence locaiton of transcript



### 8. Design probes in stellaris and order




