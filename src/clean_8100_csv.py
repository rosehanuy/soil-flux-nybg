import os
import pandas as pd

def clean_8100_csv(csv_file):
    """Format CSV files from Soil Flux Pro for preliminary data analysis"""
    
    file = csv_file
    df = pd.read_csv(file,skiprows=1,usecols=[0,1,4,5])   # read in csv, select columns to use

    df['Site'] = df['COMMENT'].str[:2]    # split label column into three new columns for site, type, and number
    df['Type'] = df['COMMENT'].str[3:5]
    df['Number'] = df['COMMENT'].str[5]
    df['Flux_Type'] = df['COMMENT'].str[-1]

    df.columns = ['Date','Chamber_Temp','Collar','CO2_Flux','Site','Type','Number','Flux_Type']    # rename columns
    df.drop(0,axis=0,inplace=True)                                      # drop unneeded first row


    df['CO2_Flux'] = df['CO2_Flux'].astype(float)                            # convert datatypes
    df['Date'] = pd.to_datetime(df['Date'])

    
    output_folder = 'C:/Users/roseh/Desktop/NYBG_R/data/processed/QC2'    # set output folder and file name
    file_name = csv_file
    path = os.path.join(output_folder,file_name)
    
    df.to_csv(path)                                   



