df <- read.csv('nybg_recat3.csv')
df2 <- read.csv('nybg_recat3_means_2.csv')

s.means <- read.csv('seasonal_means_2.csv')
s.medians <- read.csv('seasonal_medians.csv')

## Create three models for all data values
mod.1 <- lm(Res~Chamber_Temp+ndvi,data=df)
summary(mod.1)

mod.2 <- lm(I(log(Res))~Chamber_Temp+ndvi,data=df)
summary(mod.2)

mod.3 <- lm(Res~log(Chamber_Temp)+ndvi,data=df)
summary(mod.3)

# Create three models for mean values
mod.1m <- lm(Mean_Respiration~Mean_Chamber+Mean_ndvi,data=df2)
summary(mod.1m)

mod.2m <- lm(log(Mean_Respiration)~Mean_Chamber+Mean_ndvi,data=df2)
summary(mod.2m)

mod.3m <- lm(Mean_Respiration~log(Mean_Chamber)+Mean_ndvi,data=df2)
summary(mod.3m)

# Plot measured seasonal mean vs. predicted seasonal mean respiration
lst.seq <- s.means$lst
ndvi.seq <- s.means$ndvi

rs.pred <- predict(mod.1m,newdata=data.frame(Mean_Chamber=lst.seq,Mean_ndvi=ndvi.seq))

plot(s.means$res,rs.pred)
abline(coef=c(0,1))

# Plot measured seasonal median vs. predicted seasonal median respiration
lst.seq2 <- s.medians$lst
ndvi.seq2 <- s.medians$ndvi

rs.pred.med <- predict(mod.1m,newdata=data.frame(Mean_Chamber=lst.seq2,Mean_ndvi=ndvi.seq2))

plot(s.medians$res,rs.pred.med)
abline(coef=c(0,1))

# linear model for median measured v. predicted
corr <- lm(rs.pred.med~s.medians$res)
summary(corr)
# linear model for mean measured v. predicted
corr.2 <- lm(rs.pred~s.means$res)
summary(corr.2)
library(ggplot2)
df.plot <- cbind(s.means,rs.pred)
df.plot2 <- cbind(s.medians,rs.pred.med)

# Predicted vs. Measured Plots
ggplot(data=df.plot,mapping=aes(x=res, y=rs.pred)) +
  geom_point(mapping=aes(color=chambernames)) +
  geom_smooth(method=lm) +
  ggtitle('Seasonal Mean Respiration: Predicted vs. Measured') +
  xlab('Measured Mean Respiration') +
  ylab('Predicted Mean Respiration')

ggsave('predicted_ct_ndvi_model.png',path='C:\\Users\\roseh\\Desktop\\NYBG_R\\reports\\figures\\eda\\model_fit')

ggplot(data=df.plot2,mapping=aes(x=res, y=rs.pred.med)) +
  geom_point(mapping=aes(color=chambernames)) +
  geom_smooth(method=lm) +
  ggtitle('Seasonal Median Respiration: Predicted vs. Measured') +
  xlab('Measured Median Respiration') +
  ylab('Predicted Median Respiration')
ggsave('predicted_ct_ndvi_model_2.png',path='C:\\Users\\roseh\\Desktop\\NYBG_R\\reports\\figures\\eda\\model_fit')


# Bar plots
res.df <- data.frame(Label=c('Measured','Predicted'),Means=c(round(sum(s.means$res),2),round(sum(rs.pred),2)),
                     Median=c(round(sum(s.medians$res),2),round(sum(rs.pred.med),2)))

ggplot(data=res.df, mapping=aes(x=Label,y=Means,fill=Label,ymax=140)) +
  geom_bar(stat='identity') +
  geom_text(aes(label=Means), position = position_dodge(width = 1),
            vjust = -0.5, size = 4) +
  ggtitle('Total Mean Respiration')
ggsave('total_means_bar.png',path='C:\\Users\\roseh\\Desktop\\NYBG_R\\reports\\figures\\eda\\model_fit')

ggplot(data=res.df,mapping = aes(x=Label,y=Median,fill=Label,ymax=140)) +
  geom_bar(stat='identity') +
  geom_text(aes(label=Median),position = position_dodge(width = 1),
            vjust = -0.5, size = 4) +
  ggtitle('Total Median Respiration')
ggsave('total_medians_bar.png',path='C:\\Users\\roseh\\Desktop\\NYBG_R\\reports\\figures\\eda\\model_fit')

           