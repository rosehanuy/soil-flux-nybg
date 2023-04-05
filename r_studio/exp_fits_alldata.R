df = read.csv('nybg_recat3_means.csv')
# create booleans
ct_boo <- !is.na(df$Mean_Chamber)
st_boo <- !is.na(df$Mean_Temp)
r_boo <- !is.na(df$Mean_Respiration)

# create dfs with no na values
df_r_st <- df[r_boo&st_boo,]  
df_r_ct <- df[r_boo&ct_boo,]

plot(df$Mean_Temp,df$Mean_Chamber,main='Mean Soil Temps v. Mean Chamber Temps')
abline(a=0,b=1)

linear_model_st <- lm(Mean_Respiration~Mean_Temp,data=df)
summary(linear_model_st)

exp_model_st <- lm(log(Mean_Respiration)~Mean_Temp,data=df)
summary(exp_model_st)


stemp_seq <- seq(0,30,length=30)
exp_stemp_pred <- exp(predict(exp_model_st,
                          newdata=data.frame(Mean_Temp=stemp_seq)))


plot(df$Mean_Temp,df$Mean_Respiration,xlab='Mean Soil Temp (C)',
     ylab='Mean micromol CO2/m^2/s',main="NYBG All Data - Means")
lines(lowess(df_r_st$Mean_Temp,df_r_st$Mean_Respiration),
      col='red')
lines(stemp_seq,exp_stemp_pred)


plot(df$Mean_Chamber,df$Mean_Respiration,
     xlab='Mean Chamber Temp (C)',
     ylab='micromol CO2/m^2/s',main="NYBG All Data - Chamber Means")
lines(lowess(df_r_ct$Mean_Chamber,df_r_ct$Mean_Respiration),
      col='red')


plot(exp_model_st)







