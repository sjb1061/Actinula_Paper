#! /usr/bin/env python3

#Dont forget to module load linuxbrew/colsa 

#import modules
import argparse

#create an instance of Argument Parser and add positional argument 
parser = argparse.ArgumentParser()
parser.add_argument("-a", help="input fasta file")

args = parser.parse_args()

try: 
    with open(args.a, "r") as in_handel: 
        with open("{0}-mod.fa".format(args.a), "w") as out_handel: 
            
            for line in in_handel: 
                if line.startswith(">"): 
                    sp_line = line.split(" ")
                    #print("first split: ", sp_line)
                    sp_line_2=sp_line[4].split("(")
                    #print("second split: ", sp_line_2)
                    sp_line_3= sp_line_2[0].split(":")
                    join_sp= "..".join(sp_line_3)
                    #print("new line after join", join_sp)                

                    new_line = ">{0}".format(join_sp)+ "\n"
                    #print("new line: ", new_line)
                    out_handel.write(new_line)
                    
                else: 
                    out_handel.write(line)

except IOError as err:
    print("problem reading or writing/appending file:", err)
