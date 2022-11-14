import os
import pandas as pd

def merge_flux_temp(flux_df,temp_df):
    
    """A function to join together a co2 flux csv file with a temperature csv file 
    and save the new csv file to data/processed/merge""" 
    
    print(f'joining {flux_df} to {temp_df}')
    flux = pd.read_csv(flux_df, usecols=['Date','CO2_Flux','Chamber_Temp','Collar','Site','Type'])
    flux['Collar'] = flux['Collar'].str[:6]
    temp = pd.read_csv(temp_df)
    merged_df = flux.merge(temp,how='inner',on='Collar')
    
    output_folder = 'C:/Users/roseh/Desktop/NYBG_R/data/processed/QC2'
    filename = f'merged_{flux_df}.csv'
    path = os.path.join(output_folder,filename)
    merged_df.to_csv(path)