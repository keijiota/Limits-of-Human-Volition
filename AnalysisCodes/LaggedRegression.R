# Copyright (C) Keiji Ota 2023
# Email: k.ota@ucl.ac.uk or k.ota@qmul.ac.uk
# Edited: 2023-11-18 

#rm(list = ls())
# https://stats.stackexchange.com/questions/238581/how-to-use-ordinal-logistic-regression-with-random-effects


library("ordinal") 
library(readxl)
library("writexl") 
library(emmeans)

#----- autogregression with random intercept: actual data----------
# load a trial-by-trial data structure
dat <- read_excel("autoreg_data_b2-4.xlsx")

dat <- data.frame(dat);
dat$resp <- factor(dat$resp, levels = c("1","2","3"),order = TRUE)
dat$ib   <- factor(dat$ib,levels = c("2","3","4"))

str(dat)

# ordinal regression analysis using Cumulative Link Model
m1 <- clm(resp ~ 1 + own1*ib + opt1*ib + own2*ib + opt2*ib + own3*ib + opt3*ib+ own4*ib + opt4*ib+ own5*ib + opt5*ib, data = dat)
summary(m1)

# ordinal regression analysis using Cumulative Link Mixed Model with random intercepets of participants
m2 <- clmm(resp ~ 1 + own1*ib + opt1*ib + own2*ib + opt2*ib + own3*ib + opt3*ib + own4*ib + opt4*ib + own5*ib + opt5*ib + (1|id), data = dat)
summary(m2)

# model comparison
anova(m1,m2)

# stat values 
anova(m1)
anova(m2,type="1")


# statistical tests on lag 1 correlation 
own1 <- emtrends(m1, ~ib, var="own1"); pairs(own1)
opt1 <- emtrends(m1, ~ib, var="opt1"); pairs(opt1)
# pairs(emtrends(m1, ~ib, var="opt1"), adjust = "none")

# extracting values 
own2 <- emtrends(m2, ~ib, var="own2");  opt2 <- emtrends(m2, ~ib, var="opt2"); 
own3 <- emtrends(m2, ~ib, var="own3");  opt3 <- emtrends(m2, ~ib, var="opt3"); 
own4 <- emtrends(m2, ~ib, var="own4");  opt4 <- emtrends(m2, ~ib, var="opt4"); 
own5 <- emtrends(m2, ~ib, var="own5");  opt5 <- emtrends(m2, ~ib, var="opt5"); 

# converting to data frame for each block
own11 <- summary(own1)[1, 2:3]; colnames(own11) <- c("Coefb1", "SEb1");
opt11 <- summary(opt1)[1, 2:3]; colnames(opt11) <- c("Coefb1", "SEb1");
own12 <- summary(own2)[1, 2:3]; colnames(own12) <- c("Coefb1", "SEb1");
opt12 <- summary(opt2)[1, 2:3]; colnames(opt12) <- c("Coefb1", "SEb1");
own13 <- summary(own3)[1, 2:3]; colnames(own13) <- c("Coefb1", "SEb1");
opt13 <- summary(opt3)[1, 2:3]; colnames(opt13) <- c("Coefb1", "SEb1");
own14 <- summary(own4)[1, 2:3]; colnames(own14) <- c("Coefb1", "SEb1");
opt14 <- summary(opt4)[1, 2:3]; colnames(opt14) <- c("Coefb1", "SEb1");
own15 <- summary(own5)[1, 2:3]; colnames(own15) <- c("Coefb1", "SEb1");
opt15 <- summary(opt5)[1, 2:3]; colnames(opt15) <- c("Coefb1", "SEb1");


own21 <- summary(own1)[2, 2:3]; colnames(own21) <- c("Coefb2", "SEb2");
opt21 <- summary(opt1)[2, 2:3]; colnames(opt21) <- c("Coefb2", "SEb2");
own22 <- summary(own2)[2, 2:3]; colnames(own22) <- c("Coefb2", "SEb2");
opt22 <- summary(opt2)[2, 2:3]; colnames(opt22) <- c("Coefb2", "SEb2");
own23 <- summary(own3)[2, 2:3]; colnames(own23) <- c("Coefb2", "SEb2");
opt23 <- summary(opt3)[2, 2:3]; colnames(opt23) <- c("Coefb2", "SEb2");
own24 <- summary(own4)[2, 2:3]; colnames(own24) <- c("Coefb2", "SEb2");
opt24 <- summary(opt4)[2, 2:3]; colnames(opt24) <- c("Coefb2", "SEb2");
own25 <- summary(own5)[2, 2:3]; colnames(own25) <- c("Coefb2", "SEb2");
opt25 <- summary(opt5)[2, 2:3]; colnames(opt25) <- c("Coefb2", "SEb2");

own31 <- summary(own1)[3, 2:3]; colnames(own31) <- c("Coefb3", "SEb3");
opt31 <- summary(opt1)[3, 2:3]; colnames(opt31) <- c("Coefb3", "SEb3");
own32 <- summary(own2)[3, 2:3]; colnames(own32) <- c("Coefb3", "SEb3");
opt32 <- summary(opt2)[3, 2:3]; colnames(opt32) <- c("Coefb3", "SEb3");
own33 <- summary(own3)[3, 2:3]; colnames(own33) <- c("Coefb3", "SEb3");
opt33 <- summary(opt3)[3, 2:3]; colnames(opt33) <- c("Coefb3", "SEb3");
own34 <- summary(own4)[3, 2:3]; colnames(own34) <- c("Coefb3", "SEb3");
opt34 <- summary(opt4)[3, 2:3]; colnames(opt34) <- c("Coefb3", "SEb3");
own35 <- summary(own5)[3, 2:3]; colnames(own35) <- c("Coefb3", "SEb3");
opt35 <- summary(opt5)[3, 2:3]; colnames(opt35) <- c("Coefb3", "SEb3");

# export to an excel file
df1 <- rbind(own11,opt11,own12,opt12,own13,opt13,own14,opt14,own15,opt15)
df2 <- rbind(own21,opt21,own22,opt22,own23,opt23,own24,opt24,own25,opt25)
df3 <- rbind(own31,opt31,own32,opt32,own33,opt33,own34,opt34,own35,opt35)
df<-cbind(df1,df2,df3)
df

write_xlsx(df,"clmm_autoreg_data_b1-3.xlsx")



