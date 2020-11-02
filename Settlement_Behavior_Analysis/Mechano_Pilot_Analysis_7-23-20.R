#Full Actinula Mechanosensory Settlement Analysis - 7/23/20

#This is a 2x4 Split Plot RCBD with 7 Blocks 
#Response variable is the Area Under the Curve (AUC) - which is calculated from settlement percentage ((AUDPC = Sum ((yi  +  yi+1)/2)*(ti+1  -  ti)))

#Main Plot = 1/2 of light box (1 chamber) --> 1st randomization is light conidition to all chambers (2 light conditions dark or low green)
#sub-plot = 1 petri Dish with 10 larva at stage 3 --> 2nd randomization is treatment to petri dishes in chamber (4 dishes per chamber = 4 trtmts)

#Factors:
#Light: Green (low intensity) and Dark (control)
#Surface Texture: Smooth(control), Fine(220), Medium(80), Course (36)

#read in, inspect, and re-classify the data
pilot_dat <- read.csv("~/Desktop/R /Actinula_Behavior_Summer_2020/Full_mechano_pilot_dat_7-23-20.csv")
pilot_dat$Light<-as.factor(pilot_dat$Light) 
pilot_dat$Surface<-as.factor(pilot_dat$Surface) 
pilot_dat$Rep<-as.factor(pilot_dat$Rep) 
str(pilot_dat)

#The ANOVA 
pilot_mod<-aov(AUC ~ Light + Rep + Error(Light:Rep) + Surface + Light:Surface, pilot_dat) 
summary(pilot_mod)

#RESULTS
#Error: Light:Rep
#          Df Sum Sq Mean Sq F value  Pr(>F)   
#Light      1   4.07    4.07   0.818 0.40060   
#Rep        6 255.82   42.64   8.567 0.00971 **
#Residuals  6  29.86    4.98                   
#---
#Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

#Error: Within
#              Df Sum Sq Mean Sq F value Pr(>F)  
#Surface        3  80.49  26.832   3.798 0.0183 *
#Light:Surface  3  12.68   4.227   0.598 0.6202  
#Residuals     36 254.32   7.064            



#### Probe Block Interactions #### 
#Exploratory model to looking at 2-way and 3-way Block interactions 
pilot.explor_mod<-lm(AUC ~ (Rep + Light + Surface)^2, pilot_dat)
anova(pilot.explor_mod)
  #Side note would need Custom F test for Rep and Light (error = Light:Rep)

pilot.explor_mod_2<-aov(AUC ~ (Rep + Light + Surface)^2 + Error(Light:Rep), pilot_dat)
summary(pilot.explor_mod_2)



## Tukey/ Means Seperation - Main Effect Analysis ##
library(agricolae)
MP_comparison<-HSD.test(pilot_dat$AUC, pilot_dat$Light, DFerror=6, MSerror = 4.977)
#RESULTS
#Green_Low         6.775000      a
#Dark_Control      6.235714      a

SP_comparison<-HSD.test(pilot_dat$AUC, pilot_dat$Surface, DFerror=36, MSerror = 7.064)
#RESULTS
#Smooth_control      8.578571      a
#Course_36           5.907143     ab
#Fine_220            5.821429      b
#Med_80              5.714286      b



#### Figures ####

## Box Plots ## 

#Effect of surface condition
boxplot(AUC ~ Surface, pilot_dat, main = "The Effect of Surface on Settlement (in green light & darkness)",
        xlab="Surface Condition", ylab= "AUC of Settlement Percentage(over 24hrs)")

#Block effect
boxplot(AUC ~ Rep, pilot_dat, main = "The Effect of Block on Settlement (in green light & darkness)",
        xlab="Surface Condition", ylab= "AUC of Settlement Percentage(over 24hrs)")


#Light Effect
boxplot(AUC ~ Light, pilot_dat, main = "The Effect of Light on Settlement",
        xlab="Light Condition", ylab= "AUC of Settlement Percentage(over 24hrs)")

#Light Effect on Smooth surface 
sub_smooth<- subset(pilot_dat, pilot_dat$Surface  == "Smooth_control")
boxplot(AUC ~ Light, sub_smooth, main = "The Effect of Light (smooth surface) on Settlement",
        xlab="Light Condition", ylab= "AUC of Settlement Percentage(over 24hrs)")


#Surface Effect in Dark
boxplot(AUC ~ Surface, sub_dark, main = "The Effect of Surface on settlement in darkness",
        xlab="Surface Condition", ylab= "AUC of Settlement Percentage(over 24hrs)")


#Surface Effect in Green light
boxplot(AUC ~ Surface, sub_green, main = "The Effect of Surface on Settlement in Green Light",
        xlab="Surface Condition", ylab= "AUC of Settlement Percentage(over 24hrs)")




## Interaction Plots ##
library(HH)
intxplot(AUC ~ Light, groups = Surface, data=pilot_dat, se=TRUE, ylim=range(pilot_dat$AUC),
         offset.scale=500)

intxplot(AUC ~ Surface, groups = Light, data=pilot_dat, se=TRUE, ylim=range(pilot_dat$AUC),
         offset.scale=500)



## Bar Graphs ## 

# Main effect of Surface
#first, get the means, by Soil type
mean.Yield <- tapply(pilot_dat$AUC, list(pilot_dat$Surface), mean) #then, get the standard deviations, by Soil type
sd.Yield <- tapply(pilot_dat$AUC, list(pilot_dat$Surface), sd) #finally, get the sample sizes, again by Soil type
n.Yield <- tapply(pilot_dat$AUC, list(pilot_dat$Surface), length) 
se.Yield <- sd.Yield/(n.Yield)**(1/2)
barplot(mean.Yield) #makes a simple barplot!
#Pimp your barplot
mids <- barplot(mean.Yield, beside = TRUE, legend = FALSE, main = "AUC of Settlement percentage (green light and darkness)", 
                xlab = "Surface",
                ylab = "AUC",
                ylim = c(0,12), col=grey(c(0.4,0.7,1)))
#now, to add error bars, we assign the barplot above to an object called "mids"
arrows(mids, mean.Yield - 2*se.Yield, mids, mean.Yield + 2*se.Yield, code = 3, angle = 90, length = 0.1)
#now add text, labeling the bars
text(mids, .5, paste(n.Yield), col=c("white", rep("black", 3)))



# Main effect of Light
#first, get the means, by Soil type
mean.Yield <- tapply(pilot_dat$AUC, list(pilot_dat$Light), mean) #then, get the standard deviations, by Soil type
sd.Yield <- tapply(pilot_dat$AUC, list(pilot_dat$Light), sd) #finally, get the sample sizes, again by Soil type
n.Yield <- tapply(pilot_dat$AUC, list(pilot_dat$Light), length) 
se.Yield <- sd.Yield/(n.Yield)**(1/2)
barplot(mean.Yield) #makes a simple barplot!
#Pimp your barplot
mids <- barplot(mean.Yield, beside = TRUE, legend = FALSE, main = "AUC of Settlement percentage (green light and darkness)", 
                xlab = "Light Condition",
                ylab = "AUC",
                ylim = c(0,10), col=grey(c(0.4,0.7,1)))
#now, to add error bars, we assign the barplot above to an object called "mids"
arrows(mids, mean.Yield - 2*se.Yield, mids, mean.Yield + 2*se.Yield, code = 3, angle = 90, length = 0.1)
#now add text, labeling the bars
text(mids, .5, paste(n.Yield), col=c("white", rep("black", 3)))


# Effect of Light on Smooth surface
#first, get the means, by Soil type
mean.Yield <- tapply(sub_smooth$AUC, list(sub_smooth$Light), mean) #then, get the standard deviations, by Soil type
sd.Yield <- tapply(sub_smooth$AUC, list(sub_smooth$Light), sd) #finally, get the sample sizes, again by Soil type
n.Yield <- tapply(sub_smooth$AUC, list(sub_smooth$Light), length) 
se.Yield <- sd.Yield/(n.Yield)**(1/2)
barplot(mean.Yield) #makes a simple barplot!
#Pimp your barplot
mids <- barplot(mean.Yield, beside = TRUE, legend = FALSE, main = " Effect of light (smooth surface) on AUC of Settlement percentage", 
                xlab = "Light Condition",
                ylab = "AUC",
                ylim = c(0,15), col=grey(c(0.4,0.7,1)))
#now, to add error bars, we assign the barplot above to an object called "mids"
arrows(mids, mean.Yield - 2*se.Yield, mids, mean.Yield + 2*se.Yield, code = 3, angle = 90, length = 0.1)
#now add text, labeling the bars
text(mids, .5, paste(n.Yield), col=c("white", rep("black", 3)))


#Surface Effect in Darkness 
#first, get the means, by Soil type
mean.Yield <- tapply(sub_dark$AUC, list(sub_dark$Surface), mean) #then, get the standard deviations, by Soil type
sd.Yield <- tapply(sub_dark$AUC, list(sub_dark$Surface), sd) #finally, get the sample sizes, again by Soil type
n.Yield <- tapply(sub_dark$AUC, list(sub_dark$Surface), length) 
se.Yield <- sd.Yield/(n.Yield)**(1/2)
barplot(mean.Yield) #makes a simple barplot!
#Pimp your barplot
mids <- barplot(mean.Yield, beside = TRUE, legend = FALSE, main = "AUC of Settlement percentage in darkness", 
                xlab = "Surface",
                ylab = "AUC",
                ylim = c(0,12), col=grey(c(0.4,0.7,1)))
#now, to add error bars, we assign the barplot above to an object called "mids"
arrows(mids, mean.Yield - 2*se.Yield, mids, mean.Yield + 2*se.Yield, code = 3, angle = 90, length = 0.1)
#now add text, labeling the bars
text(mids, .5, paste(n.Yield), col=c("white", rep("black", 3)))


#Surface Effect in Green Light 
#first, get the means, by Soil type
mean.Yield <- tapply(sub_green$AUC, list(sub_green$Surface), mean) #then, get the standard deviations, by Soil type
sd.Yield <- tapply(sub_green$AUC, list(sub_green$Surface), sd) #finally, get the sample sizes, again by Soil type
n.Yield <- tapply(sub_green$AUC, list(sub_green$Surface), length) 
se.Yield <- sd.Yield/(n.Yield)**(1/2)
barplot(mean.Yield) #makes a simple barplot!
#Pimp your barplot
mids <- barplot(mean.Yield, beside = TRUE, legend = FALSE, main = "AUC of Settlement percentage in Low Green Light", 
                xlab = "Surface",
                ylab = "AUC",
                ylim = c(0,15), col=grey(c(0.4,0.7,1)))
#now, to add error bars, we assign the barplot above to an object called "mids"
arrows(mids, mean.Yield - 2*se.Yield, mids, mean.Yield + 2*se.Yield, code = 3, angle = 90, length = 0.1)
#now add text, labeling the bars
text(mids, .5, paste(n.Yield), col=c("white", rep("black", 3)))



## Line Graphs over Time ## 

#Import data 
line_pilot_dat <- read.csv("~/Desktop/R /Actinula_Behavior_Summer_2020/Line_graph_Pilot_data.csv")
line_pilot_dat$Light<-as.factor(line_pilot_dat$Light) 
line_pilot_dat$Surface<-as.factor(line_pilot_dat$Surface) 
line_pilot_dat$Rep<-as.factor(line_pilot_dat$Rep) 
str(line_pilot_dat)


library("ggpubr")
#Total Data - Light
ggline(line_pilot_dat, x = "Time", y = "AUC", color = "Light",
       add = c("mean_se"), xlab="Time Point in Hours", ylab="AUC of Settlement Percentage", main="The Effect of Light over Time on Settlement",
       palette = c("grey18","springgreen4"))

#Total Data - Surface
ggline(line_pilot_dat, x = "Time", y = "AUC", color = "Surface",
       add = c("mean_se"), xlab="Time Point in Hours", ylab="AUC of Settlement Percentage", main="The Effect of Surface over Time on Settlement",
       palette = c("grey18","springgreen4","steelblue2","tomato2"))

#Subset Data 
line_sub_dark<- subset(line_pilot_dat, line_pilot_dat$Light  == "Dark")
line_sub_green <- subset(line_pilot_dat, line_pilot_dat$Light == "Green_Low")
line_sub_smooth<-subset(line_pilot_dat, line_pilot_dat$Surface == "Smooth")

#Green Sub Data - Surface
ggline(line_sub_green, x = "Time", y = "AUC", color = "Surface",
       add = c("mean_se"), xlab="Time Point in Hours", ylab="AUC of Settlement Percentage", main="The Effect of Surface over Time on Settlement in Green Light",
       palette = c("grey18","springgreen4","steelblue2","tomato2"))


#Dark Sub Data - Surface
ggline(line_sub_dark, x = "Time", y = "AUC", color = "Surface",
       add = c("mean_se"), xlab="Time Point in Hours", ylab="AUC of Settlement Percentage", main="The Effect of Surface over Time on Settlement in Darkness",
       palette = c("grey18","springgreen4","steelblue2","tomato2"))

#Smooth sub Data - Light
ggline(line_sub_smooth, x = "Time", y = "AUC", color = "Light",
       add = c("mean_se"), xlab="Time Point in Hours", ylab="AUC of Settlement Percentage", main="The Effect of Light (smooth surface) over Time on Settlement",
       palette = c("grey18","springgreen4"))


