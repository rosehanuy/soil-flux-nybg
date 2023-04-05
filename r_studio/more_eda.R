
library(tidyverse)
library(lubridate)
library(GGally)
library(rstudioapi)

wd <- 'C:\\Users\\roseh\\Desktop\\NYBG_R\\Lamont\\data'
setwd(wd)

df <- read_csv('lamont_all_main.csv')
# convert data types
df$date <- mdy(df$date)
df$type <- as.factor(df$type)

# filter outlier
df <- df %>%
  filter(lin_flux < 40)
# filter out SV category
#df <- df %>%
  #filter(type != 'SV')
# create df of mean values
df.m <- df %>%
  group_by(date,type) %>%
  summarize(mean_res = mean(lin_flux,na.rm=T),
            mean_temp = mean(chamber_temp,na.rm=T),
            mean_ndvi = mean(hh_ndvi,na.rm=T),
            mean_soil = mean(soil_temp,na.rm=T))

# function to plot temp v respiration
all_data_plot <- function(df,x,xlab){
  ggplot(df, aes(x=x,y=lin_flux)) +
    geom_point(aes(x=x,y=lin_flux,color=type)) + 
    geom_smooth() +
    ggtitle('Lamont All Data, June-Oct.') +
    xlab(xlab) +
    ylab('micromol CO2/m^2/s')
}
# function to plot mean temps v mean respiration
mean_data_plot <- function(df,x,xlab){
  ggplot(df, aes(x=x,y=mean_res)) +
    geom_point(aes(x=x,y=mean_res,color=type)) + 
    geom_smooth() +
    ggtitle('Lamont All Data Means, June-Oct.') +
    xlab(xlab)+
    ylab('micromol CO2/m^2/s')
}

# function to plot facet wrap
facet_plot <- function(df,x,xlab){
  ggplot(df, aes(x=x,y=lin_flux)) +
    geom_point(aes(x=x,y=lin_flux,color=type)) + 
    geom_smooth() +
    facet_wrap(~type,nrow=2) +
    ggtitle('Lamont All Data, June-Oct.') +
    xlab(xlab)+
    ylab('micromol CO2/m^2/s')
}

facet_means <- function(df,x,xlab){
  ggplot(df, aes(x=x,y=mean_res)) +
    geom_point(aes(x=x,y=mean_res,color=type)) + 
    geom_smooth() +
    facet_wrap(~type,nrow=2) +
    ggtitle('Lamont Mean Data, June-Oct.') +
    xlab(xlab)+
    ylab('micromol CO2/m^2/s')
}

# plot chamber temp and soil temp v respiration
all_data_plot(df,df$chamber_temp,'Chamber Temperature')
all_data_plot(df,df$soil_temp,'Soil Temperature')
# plot mean chamber and mean soil temp v mean respiration
mean_data_plot(df.m,df.m$mean_temp,'Chamber Temperature')
mean_data_plot(df.m,df.m$mean_soil,'Soil Temperature')
# plot temp v. resp by type
facet_plot(df,df$soil_temp,'Soil Temperature')
facet_plot(df,df$chamber_temp,'Chamber Temperature')

facet_means(df.m,df.m$mean_soil,'Soil Temperature')
facet_means(df.m,df.m$mean_temp,'Chamber Temperature')

# function to make boxplots of temperature and respiration by type
make_boxplot <- function(df,y,ylab){
  ggplot(df)+
    geom_boxplot(aes(x=type, y=y,fill=type)) +
    ggtitle('Lamont All Data, June-Oct: ' , ylab) +
    xlab('Type')+
    ylab(ylab)
}
# make boxplot for chamber temperature
df2 <- df %>%
  mutate(type=fct_reorder(.f = type, .x = Chamber_Temp, .fun = median, na.rm = T))
make_boxplot(df2,df2$Chamber_Temp,'Chamber Temperature')
# make boxplot for respiration
df3 <- df %>%
  mutate(type=fct_reorder(.f = type, .x = Res, .fun = median, na.rm = T))
make_boxplot(df3,df3$Res,'Respiration')
# make boxplot for soil temperature
df4 <- df %>%
  mutate(type=fct_reorder(.f=type,.x=`Soil temperature`,.fun=median,na.rm=T))
make_boxplot(df4,df4$`Soil temperature`,'Soil Temperature')


# create scatterplot matrix to see relationships between variables
m.res <- df.m$mean_res
m.temp <- df.m$mean_temp
m.ndvi <- df.m$mean_ndvi
m.soil <- df.m$mean_soil
df5 <- tibble(m.res,m.temp,m.ndvi,m.soil)
ggpairs(df5)

ndvi <- df %>%
  filter(!is.na(hh_ndvi))
  
# compare ndvi measurements from different sources
ndvi <- df %>%
  filter(!is.na(hh_ndvi)) %>%
  pivot_longer(cols=c('sentinel_ndvi','sentinel_evi'),
               names_to = 'data_source',values_to = 'value')

ggplot(ndvi,aes(x=hh_ndvi,y=value,color=data_source)) +
  geom_point() +
  ylab('Satellite NDVI / EVI') +
  xlab('In Situ NDVI') +
  ggtitle('In Situ NDVI v. Satellite') +
  facet_wrap(~data_source,nrow=2)


ndvi2 <- df %>% 
  filter(!is.na(hh_ndvi)) %>%
  pivot_longer(cols=c('hh_ndvi','sentinel_ndvi','sentinel_evi'),
               names_to = 'data_source',values_to = 'value')
               
ggplot(ndvi2,aes(x=Res,y=value,color=data_source)) +
  geom_point() +
  ylab('NDVI / EVI') +
  xlab('Respiration') +
  ggtitle('NDVI v. Respiration') +
  facet_wrap(~data_source,nrow=2)

# satellite ndvi/edvi does not correlate well with in situ measurements

# define several models
mod1 <- lm(mean_res ~ mean_temp + mean_ndvi,df.m)
summary(mod1) # r2 = .906, mean_temp not significant

mod2 <- lm(mean_res ~ mean_soil + mean_ndvi,df.m)
summary(mod2) # r2 = .964, mean_soil p = .06

mod3 <- lm(mean_res ~ I(log(mean_soil)) + I(log(mean_ndvi)),df.m)
summary(mod3) # r2 = .943, mean_soil p = .08

mod4 <- lm(log(mean_res) ~ mean_soil + mean_ndvi,df.m) # significant!!
summary(mod4) # r2 = .996, variables p < .00
mod4a <- lm(log(Res) ~ `Soil temperature` + hh_ndvi,df)
summary(mod4a) # r2 = .808, variables p < .000

# compare residuals
ggplot(mod4,aes(x=.fitted,y=.resid))+
  geom_point()+
  geom_hline(yintercept=0)

ggplot(mod4a,aes(x=.fitted,y=.resid))+
  geom_point()+
  geom_hline(yintercept=0)


# compare measured vs. predicted mean respiration
season <- read_csv('seasonal_means_may_sept.csv')

lst.seq <- season$lst
ndvi.seq <- season$ndvi
evi.seq <- season$evi

compare_plot <- function(x2,title){
  predicted <- exp(predict(mod4, newdata=data.frame(mean_soil=lst.seq,
                                                    mean_ndvi=x2))) 
  df.plot <- cbind(season,predicted)
  print(sum(df.plot$predicted))
  ggplot(df.plot,aes(x=res,y=predicted)) +
    geom_point() +
    ylim(5,25) +
    ggtitle(title)
  
  
}

compare_plot(ndvi.seq,'Measured v. Predicted Mean R, x1 = LST, x2 = NDVI')
compare_plot(evi.seq, 'Measured v. Predicted Mean R, x1 = LST, x2 = EVI')


# matrix to compare relationships among variables
matrix <- season %>%
  select(soil_temps,res,ndvi,lst)

ggpairs(matrix)

# compare measured vs. predicted median respiration
season.med <- read_csv('seasonal_medians_may_sept.csv')

lst.seq.d <- season.med$lst
ndvi.seq.d <- season.med$ndvi
evi.seq.d <- season.med$evi

compare_plot_med <- function(x2,title){
  predicted <- exp(predict(mod4, newdata=data.frame(mean_soil=lst.seq.d,
                                                    mean_ndvi=x2))) 
  df.plot <- cbind(season,predicted)
  print(sum(df.plot$predicted))
  ggplot(df.plot,aes(x=res,y=predicted)) +
    geom_point() +
    ylim(5,25) +
    ggtitle(title)
  
}

compare_plot_med(ndvi.seq.d,'Measured v. Predicted Median R, x1 = LST, x2 = NDVI')
compare_plot_med(evi.seq.d,'Measured v. Predicted Median R, x1 = LST, x2 = EVI')

