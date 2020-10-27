# Step by Step Methods of Transcriptome Analysis and Outputs

This file is the step by step instructions of our Transcriptome analysis. You will find the scripts used and an explanation of what they do as well as outputs.  

### 1. Prep Reads for Transcriptome Assembly
   We sequenced the 6 developmental stages of the actinula larva: star embryo, preactinula, actinula(premature), settling actinula(competent), settled, metamorphosed Juvenile polyps. We have 6 replicates for each of the 6 devleopmental stages. The first step of our developmental transcriptome assembly is to prepare our reads for assembling a reference transcriptome. Here in this step you can either run the full cohesive script: 1_Full_Ref_Transcriptome_prep.py or run it as 2 scripts (1_steps_1-3a_v3.py and 1_steps_3b-4b.py) but with running it as 2 scripts you have to hardcode a collection in the second script (I would recommend running just the cohesive script which is what I demonstrate below).   
   
   **The goal of 1_Full_Ref_Transcriptome_prep.py** is to identify the highest quality replicate for each of the 6 stages and then concatenate the high-quality reps into representitive R1 and R2 files to be used in the assembly. The way this script identifies high-quality reps is by running FastQC on each R1 and R2 file for all reps in all stages and then calculating the following basic stats from the FastQC data:  
   
  1. ID the number of nucleotides: num_nucs = Number of Sequences * Read Length.  
  2. ID Normalized Quality: norm_qual = (Quality (the avg of means from FastQC file) - total min across all files)/(total max - total min).  
  3. Calculate Final Score: final_score = num_nucs * norm_qual.   

   The script then compares each of the final scores within each stage and then concatenates the 6 highest quality reads (1 from each stage) into a total_R1.fastq.gz and total_R2.fastq.gz (the output files). The script will also report the time it took to run the full script and a FastQC dir with all the FastQC results (note: the FastQC step will take the longest). 
   
   To run this script you will need to organize your directory as such:   
    `mkdir ORP_Prep`.  
    `mkdir ORP_Prep/raw_larva_reads`.    
    
   Within raw_larva_reads you should have subdirectories for each sample. Rename your subdirs with this format: STG_1_R1, STG_1_R2, STG_1_R3, ... If you need to add additional info after the R# add a dash and the info (STG_1_R3-additional-info). For the actinula data there are a total of 36 sub dirs with a total of 72 files (an R1 and R2 read file for each sample).   
   
   Once your directory is set up, run the script:   
   `./1_Full_Ref_Transcriptome_prep.py -d ORP_Prep`  
    
   The highest quality replicates that are used in the Reference transcriptome are:  
   winners_R1 = ['STG_3_R2.R1', 'STG_5_R2.R1', 'STG_2_R4.R1', 'STG_6_R4.R1', 'STG_1_R6.R1', 'STG_4_R3.R1']   
   winners_R2 = ['STG_3_R2.R2', 'STG_5_R2.R2', 'STG_2_R4.R2', 'STG_6_R4.R2', 'STG_1_R6.R2', 'STG_4_R3.R2']  
   
   
### 2. Run Transcriptome Assembler: Oyster River Protocol (ORP)    
   Now that we have our representative R1 and R2 files, we can assemble the transcriptome. Here we used the ORP which generates 3 assemblies and merges them into 1 high quality assembly. More information on this method can be found here: https://oyster-river-protocol.readthedocs.io/en/latest/  
   
   Submit the slurm:   
   `sbatch 2_ORP.slurm`  
   
   The code in this slurm (full slurm script can be found in scripts_for_analysis folder):   
   ```oyster.mk \   
   MEM=150 \   
   CPU=24 \   
   READ1=total_R1.fastq.gz \   
   READ2=total_R2.fastq.gz \   
   RUNOUT=actinula_total.  
   ```

   Output Quality Metrics for the assembly:  
   
   *****  QUALITY REPORT FOR: actinula_total using the ORP version 2.2.8 ****    
   *****  THE ASSEMBLY CAN BE FOUND HERE: /mnt/lustre/plachetzki/sjb1061/ectopleura_transcriptomics/assemblies/actinula_total.ORP.fasta ****.   

   *****  BUSCO SCORE ---------------------->      C:98.3%[S:64.0%,D:34.3%],F:1.3%,M:0.4%,n:303.  
   *****  TRANSRATE SCORE ------------------>      0.34022.  
   *****  TRANSRATE OPTIMAL SCORE ---------->      0.39494.  
   *****  UNIQUE GENES ORP ----------------->      16573.  
   *****  UNIQUE GENES TRINITY ------------->      15118.  
   *****  UNIQUE GENES SPADES55 ------------>      14755.  
   *****  UNIQUE GENES SPADES75 ------------>      13630.  
   *****  UNIQUE GENES TRANSABYSS ---------->      12942.  
   *****  READS MAPPED AS PROPER PAIRS ----->      93.35%.  	


### 3. Quantify Reads - Run Salmon
   Before we quantify our reads, we first need to change the headers in our new assembly. Some of the headers are very long and will be difficult to work with when we run Transdecoder in the next step so it is better to re-format the headers now. 
   
   To reformat the headers, Run 3.A_rename_fa_headers.py.   
   `./3.A_rename_fa_headers.py -a actinula_total.ORP.fa -b Ec_actinula`   
   
   The second argument here is the base of the new header, this script counts each header in order so the first header will look like: Ec_actinula_t.1   
  
   The output from this script will be the modified fasta file:  actinula_total.ORP.fa-mod.fa
     
   Now that the headers have been reformated, we can use this assembly in Salmon which quantifies reads. Info on salmon can be found here: https://salmon.readthedocs.io/en/latest/salmon.html#using-salmon. The two inputs you will need for this program are the assembly and all of the raw reads. This slurm script (3.B_salmon.slurm) will map each replicate to the assembly (note: you only have to make the index once). 
   
   Run the salmon Slurm.  
   `sbatch 3.B_salmon.slurm`  
   
   Output: You will get directories for each sample - here I secure copied all of my output directories to my desktop and placed them in a folder named mapping. This will be used with EdgeR to find DEGs and when making heatmaps in R towards the end of this workflow. 
   
### 4. Run TransDecoder 
   Next we need to translate our assembly into protien space so we can use our assembly in Orthofinder in the next step. We will also have to alter the headers again keeping only valuable information and then we will reduce the assembly by using cd-hit to get rid of duplicates. For more info on transdecoder go here: https://github.com/TransDecoder/TransDecoder/wiki.  
   
   ##### First, run Transdecoder:    
   `sbatch 4.A_transdecoder.slurm`   
   
   The code in the slurm is:  
   `TransDecoder.LongOrfs -t actinula_total.ORP.fa-mod.fa`.    
   Use the longest_orfs.pep file in the transdecoder dir - copy the file and rename it: actinula_total_ORP_prot.fa   
   
   ##### Next, rename the headers in the prot fasta:   
   `./4.B_rename_prot_headers.py -a actinula_total_ORP_prot.fa`      
   
   The headers after running Transdecoder look like:   
    >Gene.1::Ec_actinula_t.1::g.1::m.1 type:complete len:236 gc:universal Ec_actinula_t.1:2328-1621(-)  
    
   This script will take the last segment of the transdecoder header (>Gene.1::Ec_actinula_t.1::g.1::m.1 type:complete len:236 gc:universal **Ec_actinula_t.1:2328-1621(-)**) and will remove the direction ((-) or (+)) and the colon to make the new header which would be: >Ec_actinula_t.1..2328-1621. This header provides the original transcript from which it came (t.#) and also provides where in that sequence it came (#-#). The output file will have the -mod.fa tag at the end of the input fasta file.   
   
   The output file is: actinula_total_ORP_prot.fa-mod.fa.  
   
   ##### Now to get rid of potential duplicates/bad sequences in the assembly, we can run cd-hit on our prot assembly:   
   `sbatch 4.C_cdhit.slurm`
   
   The code in the slurm:
   
   
  
   
   
   
   
   

