"""Concatenates multiple csv files in a directory into one file"""
 # import libraries
import os
import glob
import pandas as pd

# define variables
basepath = 'C:/Users/roseh/Desktop/NYBG_R/'
file_location = 'data/interim'

# List all files in a directory using os.listdir
for entry in os.listdir(basepath):
    print(entry)

# change working directory
os.chdir(os.path.join(basepath, file_location))

# create list of all csv files in directory
extension = 'csv'
all_filenames = [i for i in glob.glob('*.{}'.format(extension))]

#combine all files in the list
combined_csv = pd.concat([pd.read_csv(f) for f in all_filenames ])
#export to csv
combined_csv.to_csv( "combined_csv.csv", index=False, encoding='utf-8-sig')