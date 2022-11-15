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

Next, Run the make_csv_from_OF_and_quant_files_and_sort_TPM.py on each OG of interest. This script will navigate to the salmon dir and will generate a CSV file that has all of the count information for each of the headers of interest, and will sort the file to have the highest expressed transcripts at the top. This script requires 4 pieces of info at execution: 1) the headers of interest file, 2) the path to the salmon dir with your read quantification info, 3) the first part of each group of transcripts (STG_1_R1, STG_2_R2 - the program can ignore the STG designation and use the important piece of info), and 4) the name of the output files.

Opsins:  
	Run script  
	`./make_csv_from_OF_and_quant_files_and_sort_TPM.py -a opsin_headers_of_interest_OG0000063 -b ../../salmon_3-13-20/ -c STG_ -d opsin_OF_expression_info`

  output:   
		opsin_OF_expression_info.csv  
		sorted_TPM_file.csv #rename: opsin_actinula_sorted_TPM_file.csv   
		
                copy to desktop  
		`scp sjb1061@premise.sr.unh.edu:./ectopleura_transcriptomics/ectopleura_probes_3-1-21/opsins/opsin_actinula_sorted_TPM_file.csv ./`  
		`scp sjb1061@premise.sr.unh.edu:./ectopleura_transcriptomics/ectopleura_probes_3-1-21/opsins/opsin_OF_expression_info.csv ./`  


Piezo:  
	Run script  
	`./make_csv_from_OF_and_quant_files_and_sort_TPM.py -a piezo_headers_of_interest_OG0001782 -b ../../salmon_3-13-20/ -c STG_ -d piezo_OF_expression_info`  
		output:  
			opsin_OF_expression_info.csv  
			sorted_TPM_file.csv #rename: piezo_actinula_sorted_TPM_file.csv   
		
                copy to desktop  
		`scp sjb1061@premise.sr.unh.edu:./ectopleura_transcriptomics/ectopleura_probes_3-1-21/piezo/piezo_actinula_sorted_TPM_file.csv ./`  
		`scp sjb1061@premise.sr.unh.edu:./ectopleura_transcriptomics/ectopleura_probes_3-1-21/piezo/piezo_OF_expression_info.csv ./`  


Run on PKD1L3:  
	Run script   
	`./make_csv_from_OF_and_quant_files_and_sort_TPM.py -a PKD1L3_headers_of_interest_OG0000024 -b ../../salmon_3-13-20/ -c STG_ -d PKD1L3_OF_expression_info`   
		output:  
			PKD1L3_OF_expression_info.csv  
			sorted_TPM_file.csv #rename: PKD1L3_actinula_sorted_TPM_file.csv    
		
		copy to desktop  
		`scp sjb1061@premise.sr.unh.edu:./ectopleura_transcriptomics/ectopleura_probes_3-1-21/PKD1L3/PKD1L3_actinula_sorted_TPM_file.csv ./`   
		`scp sjb1061@premise.sr.unh.edu:./ectopleura_transcriptomics/ectopleura_probes_3-1-21/PKD1L3/PKD1L3_OF_expression_info.csv ./`  


Run on PKD2L1:   
	Run script   
	`./make_csv_from_OF_and_quant_files_and_sort_TPM.py -a PKD2L1_headers_of_interest_OG0000899 -b ../../salmon_3-13-20/ -c STG_ -d PKD2L1_OF_expression_info`  
		output:  
			PKD2L1_OF_expression_info.csv  
			sorted_TPM_file.csv #rename: PKD2L1_actinula_sorted_TPM_file.csv   
		
		copy to desktop  
		`scp sjb1061@premise.sr.unh.edu:./ectopleura_transcriptomics/ectopleura_probes_3-1-21/PKD2L1/PKD2L1_actinula_sorted_TPM_file.csv ./`  
		`scp sjb1061@premise.sr.unh.edu:./ectopleura_transcriptomics/ectopleura_probes_3-1-21/PKD2L1/PKD2L1_OF_expression_info.csv ./`   


Run on TRP:   
	Run script    
	`./make_csv_from_OF_and_quant_files_and_sort_TPM.py -a TRP_headers_of_interest_OG0000887 -b ../../salmon_3-13-20/ -c STG_ -d TRP_OF_expression_info`  
		output:   
			TRP_OF_expression_info.csv   
			sorted_TPM_file.csv #rename: TRP_actinula_sorted_TPM_file.csv   
		
		copy to desktop  
		`scp sjb1061@premise.sr.unh.edu:./ectopleura_transcriptomics/ectopleura_probes_3-1-21/TRP/TRP_actinula_sorted_TPM_file.csv ./`  
		`scp sjb1061@premise.sr.unh.edu:./ectopleura_transcriptomics/ectopleura_probes_3-1-21/TRP/TRP_OF_expression_info.csv ./`  



### 5. Select the highest expressed actinula sequences for each OG 
  Next we will select the highest expressed actinual transcripts to investigate as our probe seequences.   
  
  1. For each of your OGs of interest, open the actinula_sorted_TPM_file.csv  
  2. Next, filter the table by the first unique transcript header and record the Sample stage/group with the highest TPMs (Transcript per million). For actinula, stages 3 and 4 are when we believe larvae are competent to settle so this is the stage we would expect high expression of sensory genes. We want to make probes out of the highest expressed transcripts during stages 3 and 4. Do this filter step for the top 2-4 highhest expressed transcripts and recrod the unique transcript header, and the TPM range of stages 3 and 4.      

### 6. Blastp highly expressed sequences 
  Next, we will look at the alignments of the sequences in each OG, which can be found in the OrthoFinder MultipleSequenceAlignments output dir. Create a new dir that will contain all of your alignments outside of the MultipleSequenceAlignments dir (side note: don't `ls` in MultipleSequenceAlignments). Then transfer alignment to desktop to view alignment   
  
  ```
     mkdir OrthoFinder/Results/OGs_of_interest_alignments
  
     cp MultipleSequenceAlignments/OG0000063.fa ./OGs_of_interest_alignments #opsin
     cp MultipleSequenceAlignments/OG0001782.fa ./OGs_of_interest_alignments #piezo
     cp MultipleSequenceAlignments/OG0000899.fa ./OGs_of_interest_alignments #PKD2L1
     cp MultipleSequenceAlignments/OG0000024.fa ./OGs_of_interest_alignments #PKD1L3
     cp MultipleSequenceAlignments/OG0000887.fa ./OGs_of_interest_alignments #TRPA1
  ```
  Next, open the file in seaviewer (or other alignment viewer) and compare the sequences - make note of potential good/bad seqs based on alignment. Then copy the actinula sequences into a text editor  and remove all dashes (find/replace dash with nothing). Now blastp the sequences in NCBI and record hits and potential sequences for probes. This is a reciprocal blast to try to verify highly expressed seqences to make probes. 
  
  ```
# Opsins OG0000063 
>actinula_total_ORP_famod_reduced_Ec_actinula_t.28006..35639	Select seq ref|XP_027053517.1|	melanopsin-B-like isoform X1 [Pocillopora damicornis]; Select seq gb|AGB67494.1|	c-like opsin [Tripedalia cystophora]
>actinula_total_ORP_famod_reduced_Ec_actinula_t.72976..1461048  #(Had K in 926 position) Select seq ref|XP_012555438.1|	PREDICTED: melanopsin-B-like [Hydra vulgaris] and Select seq gb|QHF16595.1|	opsin [Hydra vulgaris].  
>actinula_total_ORP_famod_reduced_Ec_actinula_t.97788..970584	Select seq gb|QHF16601.1|	opsin [Hydra vulgaris]
>actinula_total_ORP_famod_reduced_Ec_actinula_t.97788..1291986	Select seq ref|XP_004211965.1|	PREDICTED: opsin-3-like [Hydra vulgaris]

#Piezo OG0001782
>actinula_total_ORP_famod_reduced_Ec_actinula_t.17544..76291057	  Select seq ref|XP_027057832.1|	piezo-type mechanosensitive ion channel component 2-like [Pocillopora damicornis]; and Select seq ref|XP_032220159.1|	piezo-type mechanosensitive ion channel component 1 [Nematostella vectensis]
>actinula_total_ORP_famod_reduced_Ec_actinula_t.46001..4422	Select seq ref|XP_032225286.1|	piezo-type mechanosensitive ion channel component 1 [Nematostella vectensis]

#PKD2L1 OG0000899
>actinula_total_ORP_famod_reduced_Ec_actinula_t.81080..2032761		Select seq ref|XP_029208330.1|	polycystic kidney disease 2-like 1 protein [Acropora millepora]
>actinula_total_ORP_famod_reduced_Ec_actinula_t.82249..1232579		Select seq ref|XP_029208330.1|	polycystic kidney disease 2-like 1 protein [Acropora millepora]

#PKD1L3 OG0000024	
>actinula_total_ORP_famod_reduced_Ec_actinula_t.66208..29401282		Select seq ref|XP_012563290.1|	PREDICTED: polycystic kidney disease 2-like 1 protein [Hydra vulgaris]
>actinula_total_ORP_famod_reduced_Ec_actinula_t.66208..40602882		Select seq ref|XP_012560253.1|	PREDICTED: polycystic kidney disease protein 1-like 2 [Hydra vulgaris]

#TRPA1 OG0000887
>actinula_total_ORP_famod_reduced_Ec_actinula_t.66269..633458		Select seq ref|XP_012557933.1|	PREDICTED: transient receptor potential cation channel subfamily A member 1-like [Hydra vulgaris]
>actinula_total_ORP_famod_reduced_Ec_actinula_t.84956..1073508		Select seq ref|XP_012565640.1|	PREDICTED: transient receptor potential cation channel subfamily A member 1-like [Hydra vulgaris]
		
```
  
### 7. Pull out FASTA sequences for all transcripts of interest and get exact sequence locaiton of transcript



### 8. Design probes in stellaris and order




