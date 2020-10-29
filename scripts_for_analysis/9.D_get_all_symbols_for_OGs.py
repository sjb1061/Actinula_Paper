#! /usr/bin/env python3

#import modules
import argparse

#create an instance of Argument Parser and add positional argument 
parser = argparse.ArgumentParser()
parser.add_argument("-a", help="input file: gene set from R (file with gene_acc OG symbol Actinula_seqid)")
parser.add_argument("-b", help="output file name - geneset name")

args = parser.parse_args()

#key = OG[2]
#value = [symbol][3] 
	
tot_db = {}
#part 1 populate dictionary with OGs and symbols
with open("{0}-all_symbols_for_OGs.txt".format(args.b), "w") as out_handle:
    with open(args.a, "r") as in_handle:
        for line in in_handle:
            line = line.rstrip()
            sp_line = line.split("\t")
            #print(sp_line)
            tot_db.setdefault(sp_line[2].strip(),[]) #set key to OG and make list as value
            tot_db[sp_line[2]].append(sp_line[3].strip()) #add symbol
            
        #print("db after 1st file: ", tot_db)
        #print(len(tot_db))   

#part 2 - unique the dictionary
unique_db = {}

for key in tot_db:
    unique_db.setdefault(key,[])
    for val in tot_db[key]: 
        if val not in unique_db[key]:
            unique_db[key].append(val)

print("unique db: ",unique_db)
print(len(unique_db))


#part 3 write to file
with open("{0}-all_symbols_for_OGs.txt".format(args.b), "w") as out_handle:
    for key in unique_db:
        out_handle.write("{0}\t".format(key))
        for value in range(len(unique_db[key])):
            #print("value: ", value)
            #print("len: ", len(unique_db[key]))
            if value+1 == len(unique_db[key]):            
                out_handle.write("{0}".format(unique_db[key][value]))
                out_handle.write("\n")
            else:
                out_handle.write("{0}, ".format(unique_db[key][value]))
        #out_handle.write("\n")

print("Your file has been created - import to R")
