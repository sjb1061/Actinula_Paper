#! /usr/bin/env python3

#This script goes through the interproscan tsv output file to get the GO terms for the headers - it will write a file with 2 columns - the first
#will be the headers, the second will have the GO terms if any are present, if there are multiple they will be seperated by commas. 

#import modules
import argparse

parser = argparse.ArgumentParser()
parser.add_argument("--input", "-i", help="pathname of input file - the tsv file from interproscan")

args = parser.parse_args()
	
	
#iterate through the tsv file and write a new file with headers and GO terms(go terms are in the 13th position, headers in 0) 
def make_annotation_file(input):
    try:
        with open("annotations.txt", "w") as out_handel:
            with open(input, "r") as in_handel: 
                for line in in_handel:
                    #print("line", line)
                    line = line.split("\t")
                    #print("after split", line)
                    id = line[0]
                    #print("id", id)

                    if len(line) < 13:
                        #new_line = id + "\n"
                        #out_handel.write(new_line)
                        continue
                    else:
                        go = line[13].strip()
                        if "|" in go:
                            fields = go.split("|")
                            go = ", ".join(fields)
                        #print("go", go)
                        new_line = "{0}{1}{2}{3}".format(id, "\t", go,"\n")
                        #print("new line", new_line)
                        out_handel.write(new_line)
					
                print("annotations.txt has been created")
    except IOError: 
        print("something went wrong reading/writing the file") 


#call function 
make_annotation_file(args.input)

