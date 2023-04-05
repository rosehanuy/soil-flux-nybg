df = read.csv('nybg_recat3.csv')

ml_boo <- df['type'] =='ML'
ul_boo <- df['type']=='UL'
fe_boo <- df['type']=='FE'
fi_boo <- df['type']== 'FI'
tp_boo <- df['type']=='TP'

ml <- df[ml_boo,]
ul <- df[ul_boo,]
fe <- df[fe_boo,]
fi <- df[fi_boo,]
tp <- df[tp_boo,]

plot(df$Soil.temperature,df$Chamber_Temp,
     main='Soil Temp v. Chamber Temp',xlab='Soil Temperature',
     ylab='Chamber Temperature')
abline(coef=c(0,1),col='red')

# Managed Lawn - soil temp
plot(ml$Soil.temperature,ml$Res,main='Soil Temp. v. CO2')

ml_lin_model <- lm(Res~Soil.temperature, data=ml)
summary(ml_lin_model)

ml_log_model <- lm(Res~log(Soil.temperature),data=ml)
summary(ml_log_model)

tempseq <- seq(min(ml$Soil.temperature,na.rm=T),
               max(ml$Soil.temperature,na.rm=T),length=30)
ml_log_predict <- predict(ml_log_model,
                          newdata=data.frame(Soil.temperature=tempseq))

plot(ml$Soil.temperature,ml$Res,main='Soil Temp. v. CO2',
     xlab='Soil Temperature',ylab='micromols CO2/m^2/s')
lines(tempseq,ml_log_predict,col='red')

# Managed Lawn - chamber temp

ml_log_model_c <- lm(Res~log(Chamber_Temp), data=ml)
summary(ml_log_model_c)


tempseq2 <- seq(min(ml$Chamber_Temp,na.rm=T),
                max(ml$Chamber_Temp,na.rm=T),length=30)
ml_log_predict_c <- predict(ml_log_model_c,
                            newdata=data.frame(Chamber_Temp=tempseq2))

plot(ml$Chamber_Temp,ml$Res,main='Chamber Temp v. CO2',
     ylab='micromols CO2/m^2/s',xlab='Chamber Temperature')
lines(tempseq2,ml_log_predict_c,col='red')

# Unmanaged Lawn
plot(ul$Soil.temperature,ul$Res,main='UL - Soil Temp v. CO2',
     xlab='Soil Temperature',ylab='micromols CO2/m^2/s')

ul_log_model <- lm(Res~log(Soil.temperature), data=ul)
summary(ul_log_model)

plot(ul$Chamber_Temp,ul$Res,main='UL - Chamber Temp v. CO2',
     xlab='Chamber Temperature',ylab='micromols CO2/m^2/s')

plot(ul$Chamber_Temp,ul$Res)

ul_log_model_c <- lm(Res~log(Chamber_Temp), data=ul)
summary(ul_log_model_c)

ul_n <- ul$Label != 'BE_UL3'
ul2 <- ul[ul_n,]

plot(ul2$Soil.temperature,ul2$Res,main='UL - Soil Temp v. CO2',
     xlab='Soil Temperature',ylab='micromols CO2/m^2/s')

plot(ul2$Chamber_Temp,ul2$Res,main='UL - Chamber Temp v. CO2',
     xlab='Chamber Temperature',ylab='micromols CO2/m^2/s')

# Tree Pit

plot(tp$Soil.temperature,tp$Res,main='TP - Soil Temp v. CO2',
     xlab='Soil Temperature',ylab='micromols CO2/m^2/s')

plot(tp$Chamber_Temp,tp$Res,main='TP - Chamber Temp v. CO2',
     xlab='Chamber Temperature',ylab='micromols CO2/m^2/s')

# Forest Interior

plot(fi$Soil.temperature,fi$Res,main='FI - Soil Temp v. CO2',
     xlab='Soil Temperature',ylab='micromols CO2/m^2/s')

plot(fi$Chamber_Temp,fi$Res,main='FI - Chamber Temp v. CO2',
     xlab='Chamber Temperature',ylab='micromols CO2/m^2/s')

# Forest Edge
plot(fe$Soil.temperature,fe$Res,main='FE - Soil Temp v. CO2',
     xlab='Soil Temperature',ylab='micromols CO2/m^2/s')

plot(fe$Chamber_Temp,fe$Res,main='FE - Chamber Temp v. CO2',
     xlab='Chamber Temperature',ylab='micromols CO2/m^2/s')
