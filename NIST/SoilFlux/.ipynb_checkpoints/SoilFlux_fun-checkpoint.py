import pandas as pd
import numpy as np
import datetime as dt


RawDatadir = "C:\\Users\\Min Tien\\Documents\\Python Scripts\\SoilFlux\\data\\Raw_Data_2022701\\"
fMetaData = 'Metadata_0712.xlsx'
# User-defined functions
def get_variables_7810(file):
    # Colume variables
    SoilFlx = pd.read_csv(file, header=2)
    SoilFlx = SoilFlx.to_numpy() #convert to array
    Temp_chamb = SoilFlx[:, 0]
    Vol_tot = SoilFlx[:, 1]
    Offset = SoilFlx[:, 2]
    Flx_expone = SoilFlx[:, 3]
    Flx_linear = SoilFlx[:, 4]
    Labels=SoilFlx[:, 7]
    Timestamps = SoilFlx[:, 8]
    Flx_R2 = SoilFlx[:, 15]
    Flx_CV = SoilFlx[:, 16]

    # Derived variables
    DT = np.array([dt.datetime.strptime(d, '%Y/%m/%d %H:%M:%S') for d in Timestamps])
    Hours= [dt.hour for dt in DT]
    Dates= [dt.date() for dt in DT]
    bNEE = np.array(['_NEE' in lab for lab in Labels])
    bR = np.array(['_NEE' not in lab for lab in Labels])
    
    return DT, Labels, Flx_linear, Flx_expone, Flx_CV, bNEE, bR, Temp_chamb

def get_variables_8100(file):
    # Colume variables
    SoilFlx = pd.read_csv(file, header=2)
    SoilFlx = SoilFlx.to_numpy() # convert to array
    Timestamps = SoilFlx[:, 0]
    Temp_chamb = SoilFlx[:, 1]
    Labels=SoilFlx[:, 4]
    Flx_linear = SoilFlx[:, 5]
    Flx_expone = SoilFlx[:, 6]
    Flx_CV = SoilFlx[:, 7]
    # Derived variables
    DT = np.array([dt.datetime.strptime(d, '%Y-%m-%d %H:%M:%S') for d in Timestamps])
    Hours= [dt.hour for dt in DT]
    Dates= [dt.date() for dt in DT]
    bNEE = np.array(['_NEE' in lab for lab in Labels])
    bR = np.array(['_R' in lab for lab in Labels])
    return DT, Labels, Flx_linear, Flx_expone, Flx_CV, bNEE, bR, Temp_chamb
    
def simple_QC(Flx_CV, Flx_linear, Flx_expone):
    Flx_real= np.empty(len(Flx_linear))
    Flx_real[:]=np.nan
    threshold = 0.1
    
    boo_qc1 = Flx_CV <1.2  #(r2 > 0.99 and) flx_CV <1.2
    for i in range(0, len(Flx_linear)):
        if Flx_CV[i]<1.2:
            Flx_real[i] = Flx_linear[i]
        else:
            if abs((Flx_linear[i]-Flx_expone[i])/Flx_linear[i])<threshold: # and Flx_CV[i]<5.0:
                Flx_real[i] = Flx_linear[i]  
    return Flx_real

def get_GPP_etc(Labels, bR, bNEE, Flx_real, DT, Labels_generic, Tcham):
    DT_R    = []
    DT_NEE  = []
    Tchamber= np.empty(len(Labels_generic))
    Flx_R   = np.empty(len(Labels_generic))
    Flx_NEE = np.empty(len(Labels_generic))  # multiple NEE measurements for one collar
    Flx_NEE1 = np.empty(len(Labels_generic))
    Flx_NEE2 = np.empty(len(Labels_generic))
    Flx_R[:]= np.nan
    Flx_NEE[:]= np.nan
    Flx_NEE1[:]= np.nan
    Flx_NEE2[:]= np.nan
    Tchamber[:]=np.nan
    
    ind=0
    for label in Labels_generic:
        # print(label)
        bLabel = np.array([label in lab for lab in Labels])
        boo_R = np.logical_and(bLabel,bR)
        boo_NEE = np.logical_and(bLabel,bNEE)

        DT_R.append(DT[boo_R])
        DT_NEE.append(DT[boo_NEE])

        if boo_R.any() == True:
            Flx_R[ind]  =Flx_real[boo_R]
            Tchamber[ind]=Tcham[boo_R]

        if boo_NEE.any() == True:
            NEE_tmp=Flx_real[boo_NEE]
            if len(NEE_tmp)==1:
                Flx_NEE[ind] = NEE_tmp
            elif len(NEE_tmp)==2:
                Flx_NEE[ind] = NEE_tmp[0]
                Flx_NEE1[ind] = NEE_tmp[1]
            elif len(NEE_tmp)==3:
                Flx_NEE[ind] = NEE_tmp[0]
                Flx_NEE1[ind] = NEE_tmp[1]
                Flx_NEE2[ind] = NEE_tmp[2]
            else:
                print('Too many repetition of NEE!!!!')

        ind+=1
        
    DT_R=np.array(DT_R)
    DT_NEE=np.array(DT_NEE)
    Flx_GPP= -Flx_R+Flx_NEE
    return Flx_GPP, Flx_R, Flx_NEE, Flx_NEE1, Flx_NEE2, DT_R, DT_NEE,Tchamber


def plot_daily_flux_vs_collar(Flx_R, Flx_NEE, Flx_NEE1, Flx_GPP, Labels):
    fig, ax = plt.subplots(1, figsize=(18, 6))
    for eco in EcoTypes:
        boo_eco = np.array([eco in lab for lab in Labels]) 
        Labels_sht = np.array([lab[3:6] for lab in Labels])
        label_eco = Labels_sht[boo_eco]
        color_eco = Colors[EcoTypes.index(eco)]

        #R
        ax.plot(label_eco, Flx_R[boo_eco], label='Res', 
                                           marker='^', 
                                           linestyle='none',
                                           markersize=MarkerSize,
                                           color = color_eco)
        #NEE
        ax.plot(label_eco, Flx_NEE[boo_eco], label='NEE',
                                             marker='o', 
                                             linestyle='none', 
                                             markersize=MarkerSize,
                                             markerFacecolor=color_eco,
                                             color = color_eco)
        ax.plot(label_eco, Flx_NEE1[boo_eco], label='_nolegend_',
                                             marker='o', 
                                             linestyle='none', 
                                             markersize=MarkerSize,
                                             markerFacecolor=color_eco,
                                             color = color_eco)
        #GPP (using R timestamp)
        ax.plot(label_eco, Flx_GPP[boo_eco], label='GEE',
                                             marker='s', 
                                             linestyle='none', 
                                             markersize=MarkerSize, 
                                             color = color_eco) 
        if eco==EcoTypes[0]:
            ax.legend(loc='upper left')

    ax.plot([-0.5, 24], [0,0], linestyle='--', color='grey') 
    ax.set_title(str(DT[0].date())+', '+ file[-13:-9]+', Licor-'+tag)  
    ax.set_ylabel('[\u03BCmol CO$_{2}$ m$^{-2}$ s$^{-1}]$', fontsize=12)
    plt.savefig(Figdir+file[-13:-9]+'_'+tag+'_'+str(DT[0].date()))
    
def get_metaData(Date, Labels):
    # Read the excel sheet
    Metadata = pd.read_excel(RawDatadir+fMetaData, sheet_name=Date[2:], header=3)
    Metadata = Metadata.to_numpy()
    Labels_exl = Metadata[:,0]
    stemp_exl = Metadata[:,4]
    smoist_exl = Metadata[:,5]
    PAR_exl = Metadata[:,6]
    atemp_exl = Metadata[:,7]

    # Get the PAR etc
    Par = np.empty(len(Labels))
    STemp = np.empty(len(Labels))
    SMoist = np.empty(len(Labels))
    ATemp = np.empty(len(Labels))
    Par[:] = np.nan
    STemp[:] = np.nan
    SMoist[:] = np.nan
    ATemp[:] = np.nan

    ind = 0
    for label in Labels:
        boo = np.array([label in lab for lab in Labels_exl])
        if boo.any() == True:
            if len(PAR_exl[boo])>1:
                if np.array([np.isnan(p) for p in PAR_exl[boo]]).all():
                    Par[ind] = np.nan
                else:
                    Par[ind] = np.nanmax(PAR_exl[boo])
            elif len(PAR_exl[boo])==1:
                Par[ind] = PAR_exl[boo]
            STemp[ind] = stemp_exl[boo][0]
            SMoist[ind] = smoist_exl[boo][0]
            ATemp[ind] = atemp_exl[boo][0]
        ind+=1

    return Par, STemp, SMoist, ATemp

def get_VPRM_grass_R(Tair):
    alpha=0.028
    beta=0.72
    return alpha*Tair+beta
    
def linear_fit(x,y):
    coef = np.polyfit(x,y,1)
    poly1d_fn = np.poly1d(coef)
    yfit=poly1d_fn(x)
    return coef,yfit

def remove_nan_for_fitting(x,y):
    boo_not_nan=np.logical_and(~np.isnan(x), ~np.isnan(y))
    xnew=x[boo_not_nan]
    ynew=y[boo_not_nan]
    return xnew,ynew

