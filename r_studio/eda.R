df <- read.csv('nybg_all.csv')
df.m <- read.csv('nybg_all_means.csv')

ml_boo <- df['type'] == 'ML'
ml.df <- df[ml_boo,]

ml_boo.m <- df.m['Type'] == 'ML'
ml.df.m <- df.m[ml_boo.m,]

ul_boo.m <- df.m['Type'] == 'UL'
ul.df.m <- df.m[ul_boo.m,]

fe_boo.m <- df.m['Type'] == 'FE'
fe.df.m <- df.m[fe_boo.m,]

fi_boo.m <- df.m['Type'] == 'FI'
fi.df.m <- df.m[fi_boo.m,]

tp_boo.m <- df.m['Type'] == 'TP'
tp.df.m <- df.m[tp_boo.m,]

library(tidyverse)
ggplot(data=df, mapping = aes(x=Chamber_Temp,y=Res)) +
  geom_point(mapping = aes(color=type)) +
  geom_smooth() +
  ggtitle('NYBG All Data') +
  xlab('Chamber Temperature (C)')+
  ylab('micromol CO2/m^2/s')

make_means_plot <- function(a){
ggplot(data=a, mapping = aes(x=Mean_Chamber,y=Mean_Respiration)) +
  geom_point(mapping = aes(color=Type)) +
  geom_smooth() +
  ggtitle('NYBG All Data - Means') +
  xlab('Mean Chamber Temperature (C)')+
  ylab('Mean micromol CO2/m^2/s')
}

make_means_plot(df.m)


ggplot(data=df) +
  geom_point(mapping=aes(x=Chamber_Temp,y=Res)) +
  geom_smooth(mapping=aes(x=Chamber_Temp,y=Res)) +
  facet_wrap(~type, nrow=2)


ggplot(data=df.m) +
  geom_point(mapping=aes(x=Mean_Chamber,y=Mean_Respiration)) +
  geom_smooth(mapping=aes(x=Mean_Chamber,y=Mean_Respiration)) +
  facet_wrap(~Type, nrow=2)

ggplot(data=df,mapping=aes(x=Type,y=Mean_Chamber)) +
  geom_boxplot(mapping=aes(fill=Type)) +
  ggtitle('Chamber Temperature by Type')

ggplot(data=df,mapping=aes(x=type,y=Res)) +
  geom_boxplot(mapping=aes(fill=type)) +
  ggtitle('Respiration by Type')

## All Data ####
log.model <- lm(Res~log(Chamber_Temp),data=df)
summary(log.model)
lin.model <- lm(Res~Chamber_Temp,data=df)
summary(lin.model)
exp.model <- lm(log(Res)~Chamber_Temp,data=df)
summary(exp.model)
### All Data Means####
m.log.model <- lm(Mean_Respiration~log(Mean_Chamber),data=df.m)
summary(m.log.model)
m.lin.model <- lm(Mean_Respiration~Mean_Chamber,data=df.m)
summary(m.lin.model)
m.exp.model <- lm(log(Mean_Respiration)~Mean_Chamber,data=df.m)
summary(m.exp.model)

#### LsT predictions using m.exp.model #####
sm.df <- read.csv('seasonal_means.csv')

lst.seq <- sm.df$lst
lst.predicted <- exp(predict(m.exp.model, newdata=data.frame(Mean_Chamber=lst.seq)))

plot(lst.predicted,sm.df$res)
abline(coef=c(0,1))

df.plot <- cbind(sm.df,lst.predicted)

ggplot(data=df.plot,mapping=aes(x=lst.predicted, y=res)) +
  geom_point(mapping=aes(color=chambernames)) +
  geom_abline() +
  ggtitle('Seasonal Mean Respiration: Predicted vs. Measured') +
  xlab('LST Predicted Mean Respiration') +
  ylab('Measured Mean Respiration')


ggplot(data=df.plot,mapping=aes(x=lst, y=chambertemp)) +
  geom_point(mapping=aes(color=chambernames)) +
  geom_abline() +
  ggtitle('LST v Chamber Temperature Correlation') +
  xlab('Seasonal Mean LST') +
  ylab('Seasonal Mean Chamber Temperature') +
  xlim(20,32) +
  ylim(20,30)

### Managed Lawn ######
ml.log.model <- lm(Res~log(Chamber_Temp),data=ml.df)
summary(ml.log.model)
ml.lin.model <- lm(Res~Chamber_Temp,data=ml.df)
summary(ml.lin.model)
ml.exp.model <- lm(log(Res)~Chamber_Temp,data=ml.df)
summary(ml.exp.model)

ml.m.log.model <- lm(Mean_Respiration~log(Mean_Chamber),data=ml.df.m)
summary(ml.m.log.model)
ml.m.lin.model <- lm(Mean_Respiration~Mean_Chamber,data=ml.df.m)
summary(ml.m.lin.model)
ml.m.exp.model <- lm(log(Mean_Respiration)~Mean_Chamber,data=ml.df.m)
summary(ml.m.exp.model)

ul.m.log.model <- lm(Mean_Respiration~log(Mean_Chamber),data=ul.df.m)
summary(ul.m.log.model)
ul.m.lin.model <- lm(Mean_Respiration~Mean_Chamber,data=ul.df.m)
summary(ul.m.lin.model)
ul.m.exp.model <- lm(log(Mean_Respiration)~Mean_Chamber,data=ul.df.m)
summary(ul.m.exp.model)

fe.m.log.model <- lm(Mean_Respiration~log(Mean_Chamber),data=fe.df.m)
summary(fe.m.log.model)
fe.m.lin.model <- lm(Mean_Respiration~Mean_Chamber,data=fe.df.m)
summary(fe.m.lin.model)
fe.m.exp.model <- lm(log(Mean_Respiration)~Mean_Chamber,data=fe.df.m)
summary(fe.m.exp.model)

fi.m.log.model <- lm(Mean_Respiration~log(Mean_Chamber),data=fi.df.m)
summary(fi.m.log.model)
fi.m.lin.model <- lm(Mean_Respiration~Mean_Chamber,data=fi.df.m)
summary(fi.m.lin.model)
fi.m.exp.model <- lm(log(Mean_Respiration)~Mean_Chamber,data=fi.df.m)
summary(fi.m.exp.model)

tp.m.log.model <- lm(Mean_Respiration~log(Mean_Chamber),data=tp.df.m)
summary(tp.m.log.model)
tp.m.lin.model <- lm(Mean_Respiration~Mean_Chamber,data=tp.df.m)
summary(tp.m.lin.model)
tp.m.exp.model <- lm(log(Mean_Respiration)~Mean_Chamber,data=tp.df.m)
summary(tp.m.exp.model)
