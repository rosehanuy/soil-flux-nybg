library(ggplot2)

df <- read.csv('nybg_recat3.csv')
df2 <- read.csv('nybg_recat3_means_2.csv')

s.means <- read.csv('seasonal_means_2.csv')
s.medians <- read.csv('seasonal_medians.csv')


ml <- df2[df2['Type']=='ML',]
ul <- df2[df2['Type']=='UL',]
ml.ul <- df2[df2['Type']=='ML' | df2['Type']=='UL',]


# Define functions to make each type of model
make_linear_means <- function(df){
  lm(Mean_Respiration~Mean_Chamber+Mean_ndvi,data=df)
  }
make_exp_means <- function(df){
  lm(log(Mean_Respiration)~Mean_Chamber+Mean_ndvi,data=df)
  }
  
make_log_means <- function(df){
  lm(Mean_Respiration~log(Mean_Chamber)+Mean_ndvi,data=df)
  }

# Create models for all data means 
linear.model.m <- make_linear_means(df2)
exp.model.m <- make_exp_means(df2)
log.model.m <- make_log_means(df2)

summary(linear.model.m)

# Create models for lawn means
lawns.linear.model.m <- make_linear_means(ml.ul)
lawns.exp.model.m <- make_exp_means(ml.ul)
lawns.log.model.m <- make_log_means(ml.ul)

# Define function to plot measured v. predicted - mean values
plot_predicted_means <- function(model,title){
  lst.seq <- s.means$lst
  ndvi.seq <- s.means$ndvi
  
  rs.pred <- predict(model,newdata=data.frame(Mean_Chamber=lst.seq,Mean_ndvi=ndvi.seq))
  
  
  df.plot <- cbind(s.means,rs.pred)
  
  ggplot(data=df.plot,mapping=aes(x=res, y=rs.pred)) +
    geom_point(mapping=aes(color=chambernames)) +
    geom_smooth(method=lm) +
    ggtitle(title) +
    xlab('Measured Mean Respiration') +
    ylab('Predicted Mean Respiration')
  
  }

plot_predicted_means(linear.model.m,'Linear Model - all data means')
plot_predicted_means(lawns.log.model.m, 'Log Model - all lawn means')

# Define function to plot measured v. predicted - median values
plot_predicted_medians <- function(model){
  lst.seq <- s.medians$lst
  ndvi.seq <- s.medians$ndvi
  
  rs.pred <- predict(model,newdata=data.frame(Mean_Chamber=lst.seq,Mean_ndvi=ndvi.seq))
  
  
  df.plot <- cbind(s.medians,rs.pred)
  
  ggplot(data=df.plot,mapping=aes(x=res, y=rs.pred)) +
    geom_point(mapping=aes(color=chambernames)) +
    geom_smooth(method=lm) +
    ggtitle('Seasonal Median Respiration: Predicted vs. Measured') +
    xlab('Measured Median Respiration') +
    ylab('Predicted Median Respiration')
}

plot_predicted_medians(linear.model.m)
plot_predicted_means(lawn.log.model.m)
