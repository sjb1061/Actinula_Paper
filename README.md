# Actinula_Paper
This contains the developmental transcriptome work for the Actinula paper along with the R scripts used to make figures

## Work Flow/Steps for Developmental Transciptome Work and Gene Set Investigation
We sequenced *Ectopleura crocea* Actinula larvae at the 6 developmental stages (star embryo, preactinula, actinula (precompetent), settling (competent), settled, and metamorphosed juvenile polyps). Samples were pooled with ~25 larva per replicate and each stage contained 6 replicates.  

#### 1. Prep Reads for Assembly
   Run two scripts which will run fastqc, perform stats, score reads, and ID the best reads for each rep of each larval stage to be used in the reference transcriptome.  
  * 1.A_steps_1-3a_v4.py
  * 1.B_steps_3b-4b.py

#### 2. Assemble - Run Oyster River Protocol (ORP)
   Submit ORP slurm. 
  * 2_orp.slurm

#### 3. Quantify Reads - Run Salmon 
   Before running salmon, change headers from the assembly and then run (2 scripts). 
  * 3.A_rename_fa_headers.py
  * 3.B_salmon.slurm

#### 4. Translate Sequences - Run Transdecoder 
   While Salmon is running, Run Transdecoder on the Assembly and then re-name the headers (2 scripts). 
  * 4.A_transdecoder.slurm
  * 4.C_rename_prot_headers.py

#### 5. Identify Orthogroups - Run OrthoFinder
   Run OrthoFinder using translated Actinula Assembly with 6 other taxa: *Homo sapiens, Drosophila, Nematostella, Hydra, Hydractinia (larva), Hydractinia (Adult)*.  
  * 5_orthofinder.slurm

#### 6. Download Gene Sets 
   Search the Broad Institute Gene Set Enrichment Analysis (GSEA) for sensory gene sets [https://www.gsea-msigdb.org/gsea/msigdb/genesets.jsp].   
   We used 3 gene sets for this paper:   
   [GO_SENSORY_PERCEPTION_OF_LIGHT_STIMULUS](https://www.gsea-msigdb.org/gsea/msigdb/cards/GO_SENSORY_PERCEPTION_OF_LIGHT_STIMULUS.html). 
   [GO_SENSORY_PERCEPTION_OF_MECHANICAL_STIMULUS](https://www.gsea-msigdb.org/gsea/msigdb/cards/GO_SENSORY_PERCEPTION_OF_MECHANICAL_STIMULUS.html). 
   [GO_SENSORY_PERCEPTION_OF_CHEMICAL_STIMULUS](https://www.gsea-msigdb.org/gsea/msigdb/cards/GO_SENSORY_PERCEPTION_OF_CHEMICAL_STIMULUS.html). 

  * A. For each gene set, click on the show members link and then copy all info into an excel file and save as csv files. 

  * B. Download Gene set sequences *(run on each gene set)* 
  *   B.1 Import CSV files to terminal 
  *   B.2 Run clean up script: 6.B.2_clean_up_csv.py
  *   B.3 Download Sequences using NCBI Entrez database (2 scripts):   
         6.B.3b_1_split_get_entrez_fasta-v5.py.    
         6.B.3b_2_split_get_entrez_fasta-v5.py.    
  *   B.4 Check for missing seqs: 6.B.4_check_missing_seqs-v2.py.  
   *Move Newly created FASTAs and gene accession files to another directory for next steps*.   

#### 7. Find Human Representative Sequences for Gene Sets from our Human protein models  
  Since we have modified the headers for our Human protien FASTA, we want to identify the NCBI sequences from the gene sets in our Human FASTA. So we are going to BLAST the NCBI gene set sequences to our Human FASTA with altered headers. We are going to create 2 files that will be used in R in the next step. 

  * A. Make blast db *(only need to run once)*:  
   7.A_blastdb.sh.    
  * B. Run BLAST *(for each gene set)*:  
   7.B_blast.sh.  
  * C. Check for any duplicates or missing seqs after blast *(for each gene set)*:  
   7.C_check_for_dups_mis.py.  
   
#### 8. Find Actinula Transcripts in Shared Orthogroups (OGs) with Sensory Genes (In R environment)
  Using the two output files (gene_symbols_accid and blastout) from step 7 and the orthofinder results, we will annotate the Orthogroups with the human gene symbols. Next we will identify the actinula sequences within the orthogroups of sensory genes for each gene set.  
   What you will need for this step:  
  * **Rscripts for each gene set:** Ec_Sensory_percep_Chem_Stim-updated.Rmd Ec_Sensory_percep_light_stim-updated.Rmd Ec_Sensory_percep_Mechan_Stim_heatmap-updated.Rmd
  * **gene_symbo_accid files for each gene set:** gene_symbol_accid_sens_percep_chem_stim gene_symbol_accid_sens_percep_light_stim gene_symbol_accid_percep_mechan_stim
  * **blastout files for each gene set:** Homo.fa_ref_blastout_sens_percep_chem_stim Homo.fa_ref_blastout_sens_percep_light_stim Homo.fa_ref_blastout_percep_mechan_stim 
  * **Orthofinder tsv file:** Orthogroups_5-11-20.tsv
  * **Orthofinder gene count file:** Orthogroups.GeneCount_5-11-20.tsv
  
#### 9. Find Significant Differentially Expressed Genes (DEGs) 
  Since we have modified the headers for our Human protien FASTA, we want to identify the NCBI sequences from the gene sets in our Human FASTA. So we are going to BLAST the NCBI gene set sequences to our Human FASTA with altered headers. We are going to create 2 files that will be used in R in the next step. 

#### 10. Generate Heatmaps of Significant DEGs of Gene Sets (In R environment)
  Since we have modified the headers for our Human protien FASTA, we want to identify the NCBI sequences from the gene sets in our Human FASTA. So we are going to BLAST the NCBI gene set sequences to our Human FASTA with altered headers. We are going to create 2 files that will be used in R in the next step. 








