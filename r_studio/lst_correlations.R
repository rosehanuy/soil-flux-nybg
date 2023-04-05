 df <- read.csv('lst_and_ground_temps.csv')               

plot(df$soil_temps,df$lst,main='Soil Temp vs. LST',
     xlab='Soil Temperature',ylab='LST',
     xlim=c(0,31),ylim=c(0,31))
abline(coef=c(0,1))

model1 <- lm(lst~soil_temps,data=df)
plot(df$soil_temps,df$lst,main='Soil Temp vs. LST',
     xlab='Soil Temperature',ylab='LST')
abline(model1)
summary(model1)

plot(df$sensor_temps,df$lst,main='Sensor Temp vs. LST',
     xlab = 'Sensor Temperature',ylab='LST',
     xlim=c(0,23),ylim=c(0,31))
abline(coef=c(0,1))

model2 <- lm(lst~sensor_temps,data=df)
plot(df$sensor_temps,df$lst,main='Sensor Temp vs. LST',
     xlab='Sensor Temperature',ylab='LST')
abline(model2)
summary(model2)

plot(df$chambertemp,df$lst,main='Chamber Temp vs. LST',
     xlab='Chamber Temperature',ylab='LST',
     xlim=c(0,30),ylim=c(0,31))
abline(coef=c(0,1))

model3 <- lm(lst~chambertemp,data=df)
plot(df$chambertemp,df$lst,main='Chamber Temp vs. LST',
     xlab='Chamber Temperature',ylab='LST')
abline(model3)
summary(model3)
