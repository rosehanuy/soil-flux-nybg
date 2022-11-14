import os
import pandas as pd

def clean_7810_csv(csv_file):
    """Format CSV files from Soil Flux Pro for preliminary data analysis"""
    
    file = csv_file
    df = pd.read_csv(file,skiprows=1,usecols=[0,4,7,8])   # read in csv, select columns to use

    df['Site'] = df['LABEL'].str[:2]    # split label column into three new columns for site, type, and number
    df['Type'] = df['LABEL'].str[3:5]
    df['Number'] = df['LABEL'].str[5]
    

    df.columns = ['Chamber_Temp','CO2_Flux','Collar','Date','Site','Type','Number']    # rename columns
    df.drop(0,axis=0,inplace=True)                                      # drop unneeded first row


    df['CO2_Flux'] = df['CO2_Flux'].astype(float)                            # convert datatypes
    df['Date'] = pd.to_datetime(df['Date'])

    
    output_folder = 'C:/Users/roseh/Desktop/NYBG_R/data/processed/QC2'    # set output folder and file name
    file_name = csv_file
    path = os.path.join(output_folder,file_name)
    
    df.to_csv(path)