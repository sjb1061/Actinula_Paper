## Work Flow/Steps for Developmental Transciptome Work and Gene Set Investigation
We sequenced *Ectopleura crocea* Actinula larvae at the 6 developmental stages (star embryo, preactinula, actinula (precompetent), settling (competent), settled, and metamorphosed juvenile polyps). Samples were pooled with ~25 larva per replicate and each stage contained 6 replicates. The goal of this work is to investigate the gene expression of sensory genes through larval development and metamorphosis. We identified sensory genes by annotating orthogroups made from Orthofinder with sensory gene sets currated by the Broad Institute Gene Set Enrichment Analysis (GSEA).   

#### 1. Prep Reads for Assembly
   Run 1 script which will run fastqc, perform stats, score reads, and ID the best reads for each rep of each larval stage to be used in the reference transcriptome.  
  * 1_Full_Ref_Transcriptome_prep.py  (there are 2 other scripts that could be used - they are just this script broken up into 2 parts - I recommend using this script)

#### 2. Assemble - Run Oyster River Protocol (ORP)
   Submit ORP slurm. 
  * 2_orp.slurm

#### 3. Quantify Reads - Run Salmon 
   Before running salmon, change headers from the assembly and then run (2 scripts). 
  * 3.A_rename_fa_headers.py
  * 3.B_salmon.slurm

#### 4. Translate Sequences - Run Transdecoder 
   While Salmon is running, Run Transdecoder on the Assembly, re-name the headers after transdecoder, and then cd-hit the assembly to remove potential duplicates (3 scripts). 
  * 4.A_transdecoder.slurm
  * 4.B_rename_prot_headers.py
  * 4.C_cdhit.slurm

#### 5. Identify Orthogroups - Run OrthoFinder
   Run OrthoFinder using translated Actinula Assembly with 6 other taxa: *Homo sapiens, Drosophila, Nematostella, Hydra, Hydractinia (larva), Hydractinia (Adult)*.  
  * 5_orthofinder.slurm

#### 6. Download Gene Sets 
   Search the Broad Institute Gene Set Enrichment Analysis (GSEA) for sensory gene sets https://www.gsea-msigdb.org/gsea/msigdb/genesets.jsp   
   
   We used 3 gene sets for this paper:   
   [GO_SENSORY_PERCEPTION_OF_LIGHT_STIMULUS](https://www.gsea-msigdb.org/gsea/msigdb/cards/GO_SENSORY_PERCEPTION_OF_LIGHT_STIMULUS.html).  
   [GO_SENSORY_PERCEPTION_OF_MECHANICAL_STIMULUS](https://www.gsea-msigdb.org/gsea/msigdb/cards/GO_SENSORY_PERCEPTION_OF_MECHANICAL_STIMULUS.html). 
   [GO_SENSORY_PERCEPTION_OF_CHEMICAL_STIMULUS](https://www.gsea-msigdb.org/gsea/msigdb/cards/GO_SENSORY_PERCEPTION_OF_CHEMICAL_STIMULUS.html). 

   ##### A. For each gene set, click on the show members link and then copy all info into an excel file and save as csv files. 

   ##### B. Download Gene set sequences *(run on each gene set)*   
  * B.1 Import CSV files to terminal   
  
  * B.2 Run clean up script: 6.B.2_clean_up_csv.py   
  
  * B.3 Download Sequences using NCBI Entrez database (2 scripts):   
    6.B.3b_1_split_get_entrez_fasta-v5.py.    
    6.B.3b_2_split_get_entrez_fasta-v5.py.    
    
  * B.4 Check for missing seqs: 6.B.4_check_missing_seqs-v2.py.  
   *Move Newly created FASTAs and gene accession files to another directory for next steps*.   

#### 7. Find Human Representative Sequences for Gene Sets from our Human protein models  
  Since we have modified the headers in our Human protien FASTA, we need to identify the NCBI sequences from the gene sets in our Human FASTA. So to do this, we are going to BLAST the NCBI gene set sequences to our Human FASTA with altered headers. We are going to create 2 files that will be used in R in the next step. 

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
  To find significant DEGs we first ran EdgeR in R. Next, we exported the significant pariwise comparisons for each stage to the terminal. Using this, we compared the headers from the sensory orthorgroups to the significant DEGs from EdgeR to identify signficant genes in the gene sets. We then ran 2 prep scripts for making the heatmaps in step 10.  

  * A. Run EdgeR script in R   
   9.A_edgeR_actinula_6_groups_0.05_4-3-20.R  

  * B. Identify significant DEGs in gene sets (in terminal)  
   9.B_find_sig_degs_in_geneset.py  
  *Run this for each pairwise comparison and compile the results into one text document for each gene set*  
  
  * Run Prep scripts for heatmaps *(run on each gene set)*.  
   9.C_prep_sig_DEGs_for_heatmaps.py     
   9.D_get_all_symbols_for_OGs.py 
  
#### 10. Generate Heatmaps of Significant DEGs of Gene Sets (In R environment)
  Now that we have identified the significant actinula DEGs in the gene sets we can visualize their expression by making heatmaps. Each script makes 2 heatmaps, the first is a heatmap of all of the actinula genes found in the gene set and the second is a heatmap of the significant DEGs found in the heat map from step 9. 

  * Using the output from the prep scripts, run the heatmap scripts in R *(run on each gene set)*  
   10_Ec_Sensory_percep_Chem_Stim_heatmap-updated.R.  
   10_Ec_Sensory_percep_light_stim_heatmap-updated.R.  
   10_Ec_Sensory_percep_Mechan_Stim_heatmap-updated.R  
   
