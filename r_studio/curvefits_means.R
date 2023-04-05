df <- read.csv('nybg_recat3_means.csv')

ml_boo <- df['Type']=='ML'
ul_boo <- df['Type']=='UL'
fe_boo <- df['Type']=='FE'
fi_boo <- df['Type']== 'FI'
tp_boo <- df['Type']=='TP'

ml <- df[ml_boo,]
ul <- df[ul_boo,]
fe <- df[fe_boo,]
fi <- df[fi_boo,]
tp <- df[tp_boo]

model_ml <- lm(Mean_Respiration~Mean_Temp,data=ml)
summary(model_ml)
exp_mod_ml <- lm(log(Mean_Respiration)~Mean_Temp,data=ml)
summary(exp_mod_ml)
plot(ml$Mean_Temp,ml$Mean_Respiration)
abline(model_ml)
