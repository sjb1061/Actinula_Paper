#! /usr/bin/env python3


#import modules        #dont forget to module load linuxbrew/colsa 
import argparse
import subprocess
import os
import gzip
import time
import shutil
from zipfile import ZipFile

#create an instance of Argument Parser and add positional argument 
parser = argparse.ArgumentParser()
parser.add_argument("--dir", "-d", help="Path to directory with sub directories of raw reads - subdir names should be in the format of group_additional-info")
#parser.add_argument("--command", "-c", help="command using the wining reads - MUST place {0} in command for where to insert read (if need R1 and R2 use {0} {1}")
#parser.add_argument("--cat", "-cat", action="store_true", help="if specified will make total R1 and total R2 files of wining reads to be used in command given")

args = parser.parse_args()

#returned collection from step 1:  
#group_db = {'STG3': ['STG_3_R6', 'STG_3_R3', 'STG_3_R4', 'STG_3_R5', 'STG_3_R1', 'STG_3_R2'], 'STG5': ['STG_5_R5', 'STG_5_R1', 'STG_5_R2', 'STG_5_R3', 'STG_5_R6', 'STG_5_R4'], 'STG2': ['STG_2_R4', 'STG_2_R2', 'STG_2_R1', 'STG_2_R6', 'STG_2_R5', 'STG_2_R3'], 'STG6': ['STG_6_R6', 'STG_6_R1', 'STG_6_R2', 'STG_6_R5', 'STG_6_R4', 'STG_6_R3'], 'STG1': ['STG_1_R5', 'STG_1_R2', 'STG_1_R1', 'STG_1_R6', 'STG_1_R3', 'STG_1_R4'], 'STG4': ['STG_4_R6', 'STG_4_R5', 'STG_4_R2', 'STG_4_R3', 'STG_4_R4', 'STG_4_R1']}
#group_db = {'STG1': ['STG_1_R2', 'STG_1_R1']} #for testing script

#returned collection from step 4a: 
winners = ['STG_3_R2.R1', 'STG_5_R2.R1', 'STG_2_R4.R1', 'STG_6_R4.R1', 'STG_1_R6.R1', 'STG_4_R3.R1']
winners_2 = ['STG_3_R2.R2', 'STG_5_R2.R2', 'STG_2_R4.R2', 'STG_6_R4.R2', 'STG_1_R6.R2', 'STG_4_R3.R2']
#winners = ['STG_1_R2.R1', 'STG_1_R1.R1']#for testing
#winners_2 = ['STG_1_R2.R2', 'STG_1_R1.R2'] #for testing

#Step 4 b) Concatenate the winning reads into Total R1 and Total R2 files (zipped)
def make_totals_files(samp_dir, win_list, win_list2):
    #change into the samples dir, if cat is present then cat all R1 and R2 files for total R1 and R2, if not present then submit reads in specified program 
    os.chdir("./fastqc_results") #only for testing - this is where we are after the previous code 
    print("Beginning concatenation of Total R1 and Total R2 files, cwd: ", os.getcwd()) #for debug
    os.chdir("../{0}".format(samp_dir))
    print("cwd after cd: ", os.getcwd()) #for debug
    
    #open two zipped files to write to - total_R1 and total_R2
    with gzip.open("total_R1.fastq.gz", "wb") as out_handel_1:
        with gzip.open("total_R2.fastq.gz", "wb") as out_handel_2:

            for idx in range(len(win_list)): 
                match_name_1 = win_list[idx]
                print("idx: ", idx)
                print("match name 1: ", match_name_1)
                match_name_2 = win_list2[idx]
                print("match name 2: ", match_name_2)
                
                #write total r1 file - read in each line and write out each line
                with gzip.open("{0}.fastq.gz".format(match_name_1), "rb") as in_handel_1:
                    print("writing for file:", match_name_1)
                    for line in in_handel_1:
                        out_handel_1.write(line)
                        
                #write total r2 file - read in each line and write out each line
                with gzip.open("{0}.fastq.gz".format(match_name_2), "rb") as in_handel_2:
                    print("writing for file", match_name_2)
                    for line in in_handel_2:
                        out_handel_2.write(line)
                    
    print("total R1 and R2 files have been made")

#Call function 
make_totals_files(args.dir, winners, winners_2)
