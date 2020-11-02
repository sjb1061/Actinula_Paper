#! /usr/bin/env python3

#import modules
import argparse
import time


#create an instance of Argument Parser and add positional argument 
parser = argparse.ArgumentParser()
parser.add_argument("-a", help="input file 1: EdgeR output 1v5")
parser.add_argument("-b", help="input file 2: EdgeR output 2v5")
parser.add_argument("-c", help="input file 3: EdgeR output 3v5")
parser.add_argument("-d", help="input file 4: EdgeR output 4v5")

args = parser.parse_args()


#name of script: find_upregulated_stg_6_genes.py
#created: 9/3/20

#Purpose: This script will go through each edgeR comparison file and will add headers of positive  
#logFC to a dictionary and will write that out to a new file --> positive = up-regulated in stg 6 

t1 = time.time()

#key = header (0 position)
#value = logFC (1 position)
		
	
tot_db = {}

#part 1 go through file 1 args.a and populate dictionary ie add upregulated genes in stg 5 (positive logFC values)
#making this as a function 

def find_upregulated_headers(file_to_open):

    with open(file_to_open, "r") as in_handle:
        for line_a in in_handle:
            line_a = line_a.rstrip()
            sp_line_a = line_a.split("\t")
            #print(sp_line_a)
            sp_line_a[0].strip()
            sp_line_a[1].strip()
            if sp_line_a[0].startswith("Ec_"):
                #print("object type before conversion: ", type(sp_line_a[1]))
                logFC_value = float(sp_line_a[1])
                #print("object type after conversion: ", type(logFC_value))

                if logFC_value > 0.0:
                    tot_db.setdefault(sp_line_a[0], logFC_value) #set key to header, and value to logFC
            else: 
                continue 
            
        print("Current dictionary: ", tot_db, len(tot_db))  


#call function 
find_upregulated_headers(args.a)
find_upregulated_headers(args.b)
find_upregulated_headers(args.c)
find_upregulated_headers(args.d)

#part 2: Write to file

with open("stg_6_upregulated_headers.txt", "w") as out_handle: 
    for key in tot_db: 
        out_handle.write(key+"\n")
print("Your file has been created! File Name: stg_6_upregulated_headers.txt")
