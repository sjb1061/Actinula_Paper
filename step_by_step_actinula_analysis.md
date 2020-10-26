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
   winners = ['STG_3_R2.R1', 'STG_5_R2.R1', 'STG_2_R4.R1', 'STG_6_R4.R1', 'STG_1_R6.R1', 'STG_4_R3.R1']   
   winners_2 = ['STG_3_R2.R2', 'STG_5_R2.R2', 'STG_2_R4.R2', 'STG_6_R4.R2', 'STG_1_R6.R2', 'STG_4_R3.R2']  
   
   
### 2. Run Transcriptome Assembler: Oyster River Protocol (ORP)    
    


