#! /usr/bin/env python3

#Dont forget to module load linuxbrew/colsa 

#import modules
import argparse

#create an instance of Argument Parser and add positional argument 
parser = argparse.ArgumentParser()
parser.add_argument("-a", help="input fasta file")
parser.add_argument("-b", help="header name")

args = parser.parse_args()

try: 
    with open(args.a, "r") as in_handel: 
        with open("{0}-mod.fa".format(args.a), "w") as out_handel: 
            
            count = 1
            for line in in_handel: 
                if line.startswith(">"): 
                    new_line = ">{0}_t.{1}".format(args.b, count)+"\n"
                    #print("new line: ", new_line)
                    out_handel.write(new_line)
                    count +=1
                else: 
                    out_handel.write(line)

except IOError as err:
    print("problem reading or writing/appending file:", err)
