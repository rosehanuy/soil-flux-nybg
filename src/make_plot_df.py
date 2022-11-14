import pandas as pd
import matplotlib.pyplot as plt
import os
import numpy as np
from scipy.stats import sem

def make_plot_df(dataframe):
    df = pd.read_csv(dataframe,usecols=['Date','Flux','Collar','Site','Type','Number']) # read in csv and select columns
    
    date = df['Date'][0][:10]
    types = []
    means=[]
    ses=[]   # standard errors
    
    type_grouped = df.groupby('Type')    # group dataframe by type
    
    if 'SV' in type_grouped.groups:         # savannah
        SV = type_grouped.get_group('SV')    
        SV_mean = SV['Flux'].mean()
        SV_se = sem(SV['Flux'])
        
        types.append('Savannah')        # append results to lists for types, means, and ses.
        means.append(SV_mean)
        ses.append(SV_se)
    else:
        pass
    
    if 'TP' in type_grouped.groups:
        TP = type_grouped.get_group('TP')    # hot lawn
        
        TP_mean = TP['Flux'].mean()
        TP_se = sem(TP['Flux'])
                    
        types.append('Tree Pit')
        means.append(TP_mean)
        ses.append(TP_se)
    else:
        pass
    
    if 'UL' in type_grouped.groups:              #unmanaged lawn
        UL = type_grouped.get_group('UL')
        
        UL_mean = UL['Flux'].mean()
        UL_se = sem(UL['Flux'])
        
        types.append('Unmanaged Lawn')
        means.append(UL_mean)
        ses.append(UL_se)
    else:
        pass
        
    
    if 'ML' in type_grouped.groups:             # managed lawn
        ML = type_grouped.get_group('ML')
        
        ML_mean = ML['Flux'].mean()
        ML_se = sem(ML['Flux'])
        
        types.append('Managed Lawn')
        means.append(ML_mean)
        ses.append(ML_se)
    else:
        pass
        
    if 'HL' in type_grouped.groups:                             # hot lawn
        HL= type_grouped.get_group('HL')
                    
        BR_HL_mean = HL['Flux'].loc[HL['Site']=='BR'].mean()    # get mean for site 1
        BW_HL_mean = HL['Flux'].loc[HL['Site']=='BW'].mean()    # get mean for site 2
        HL_array = np.array([BR_HL_mean,BW_HL_mean])            

        HL_mean = HL_array.mean()                               # get mean and se of the site means
        HL_se = sem(HL_array)
       
        types.append('Hot Lawn')
        means.append(HL_mean)
        ses.append(HL_se)
    else:
        pass
                    
                    
    if 'FE' in type_grouped.groups:     # forest edge
        FE = type_grouped.get_group('FE')    
        FE_34_mean = FE['Flux'].loc[(FE['Number']==3) | (FE['Number']==4)].mean()
        FE_12_mean = FE['Flux'].loc[(FE['Number']==1) | (FE['Number']==2)].mean()
        FE_array = np.array([FE_34_mean,FE_12_mean])

        FE_mean = FE_array.mean()
        FE_se = sem(FE_array)
        
        types.append('Forest Edge')
        means.append(FE_mean)
        ses.append(FE_se)
    else:
        pass
                    
    if 'FI' in type_grouped.groups:          # forest interior
        FI = type_grouped.get_group('FI')    
        FI_34_mean = FI['Flux'].loc[(FI['Number']==3) | (FI['Number']==4)].mean()
        FI_12_mean = FI['Flux'].loc[(FI['Number']==1) | (FI['Number']==2)].mean()
        FI_array = np.array([FI_34_mean,FI_12_mean])

        FI_mean = FI_array.mean()
        FI_se = sem(FI_array)
        
        types.append('Forest Interior')
        means.append(FI_mean)
        ses.append(FI_se)
    else:
        pass
    
    data = {'date': date,
            'type': types,      # create dictionary for dataframe
            'mean':means,
            'se':ses}
                    
    plot_df = pd.DataFrame(data)         # create dataframe
                    
    output_folder = 'C:/Users/roseh/Desktop/NYBG_R/data/processed'    # save dataframe as csv to data/processed folder
    filename = 'plot_' + dataframe
    path = os.path.join(output_folder,filename)
    plot_df.to_csv(path)