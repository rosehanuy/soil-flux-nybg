import os
import pandas as pd

def clean_csv(csv_file):
    """Format CSV files from Soil Flux Pro for preliminary data analysis"""
    
    file = csv_file
    df = pd.read_csv(file,skiprows=1,usecols = ['DATE_TIME initial_value', 'FCO2_DRY LIN', 'FCO2_DRY LIN_R2', 'LABEL'])   # read in csv, select columns to use

    df['Site'] = df['LABEL'].str[:2]    # split label column into three new columns for site, type, and number
    df['Type'] = df['LABEL'].str[3:5]
    df['Number'] = df['LABEL'].str[5]

    df.columns = ['Date','Flux','R2','Collar','Site','Type','Number']    # rename columns
    df.drop(0,axis=0,inplace=True)                                      # drop unneeded first row


    df['Flux'] = df['Flux'].astype(float)                            # convert datatypes
    df['Date'] = pd.to_datetime(df['Date'])
    
    output_folder = 'C:/Users/roseh/Desktop/NYBG_R/data/processed'    # set output folder and file name
    file_name = csv_file
    path = os.path.join(output_folder,file_name)
    
    df.to_csv(path)                                   