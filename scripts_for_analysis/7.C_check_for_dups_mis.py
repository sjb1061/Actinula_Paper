#! /usr/bin/env python3

#import modules
import argparse
import time

#create an instance of Argument Parser and add positional argument 
parser = argparse.ArgumentParser()
parser.add_argument("-a", help="input file: gene_symbol_accid")
parser.add_argument("-b", help="input file: blasout")

args = parser.parse_args()

t1 = time.time()

#key = seqid of interest (from blastout [1])
#value = [accid, OG, symbol]

tot_db = {}

#part 1 make db with seqid as key and a list with accid as the value
with open("duplicates_and_missing", "a") as out_handle:
    with open(args.a, "r") as in_handle:
        for line_a in in_handle:
            line_a = line_a.rstrip()
            sp_line_a = line_a.split("\t")
            tot_db.setdefault(sp_line_a[1], 0) #set key to accid

        #print("part 1 dict: ", tot_db)
        print("number of keys: ", len(tot_db))

#part 2 add all human OGs to corresponding seqid of interest 
    with open(args.b, "r") as in_handle_2:
        for line_b in in_handle_2:
            line_b = line_b.rstrip()
            sp_line_b = line_b.split("\t")
            #print(sp_line_b)
            #print("split accid: ", sp_line_b[0])
            if sp_line_b[0] in tot_db:
                #print("acc in dict {0} value: {2}".format(sp_line_b[0], tot_db[sp_line_b[0]]))
                tot_db[sp_line_b[0]] += 1
                #print("new value number: ", tot_db[sp_line_b[0]])
        print("fully populated dict: ", tot_db)
        
        out_handle.write("Duplicate Accids \n")               
        out_handle.write("Accid\tnumber of duplicates\n")        
        for key in tot_db:
            #print("key: ", key)
            #print("value: ", tot_db[key])
            #print("type: ", type(tot_db[key]))
            if tot_db[key] > 1: 
                #print("key: {0} and value: {1}".format(key, tot_db[key]))
                #print("entrez id: {0}".format(tot_db[key][0]))
                out_handle.write("{0}\t{1}\n".format(key, tot_db[key]))
                
        out_handle.write("Missing Accids \n")               
        out_handle.write("Accid\tnumber of duplicates\n")        
        for key in tot_db:
            #print("len of list: ", len(tot_db[key]))
            if tot_db[key] == 0: 
                out_handle.write("{0}\t{1}\n".format(key, tot_db[key]))
