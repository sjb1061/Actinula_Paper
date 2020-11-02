#Full Actinula Settlement Behavior Analysis - 7/20/20

#This is a 7x4 Split Plot RCBD with 10 Blocks 
#Response variable is the Area Under the Curve (AUC) - which is calculated from settlement percentage ((AUDPC = Sum ((yi  +  yi+1)/2)*(ti+1  -  ti)))

#Main Plot = 1/2 of light box (1 chamber) --> 1st randomization is light condition for all chambers (7 light conditions)
#sub-plot = 1 petri Dish with 10 larva at stage 3 --> 2nd randomization is treatment to petri dishes in chamber (4 dishes per chamber = 4 trtmts)
#Trtmt A = no biofilm, no texture
#Trtmt B = Biofilm present, no texture
#Trtmt C = no Biofilm, Texture present
#Trtmt D = Biofilm present, Texture present 


#read in, inspect, and re-classify the data
behav_dat <- read.csv("~/Desktop/R /Actinula_Behavior_Summer_2020/Full_behavior_dat_2020.csv")

behav_dat$Block<-as.factor(behav_dat$Block) 
behav_dat$Light_Condition<-as.factor(behav_dat$Light_Condition) 
behav_dat$Chamber<-as.factor(behav_dat$Chamber) 
behav_dat$Placement<-as.factor(behav_dat$Placement) 
str(behav_dat)

#The ANOVA - Two Way
#behav_mod<-aov(AUC ~ Light_Condition + Block + Error(Light_Condition:Block) + Trtmt + Light_Condition:Trtmt, behav_dat) 
#summary(behav_mod)

#The ANOVA - Three way - split up Chem and Mech - What we used in this analysis 
behav_mod_2<-aov(AUC ~ Light_Condition + Block + Error(Light_Condition:Block) + Light_Condition*Chem*Mech, behav_dat) 
summary(behav_mod_2)



## Probe Block Interactions ## 

#Exploratory model to looking at 2-way Block interactions   For 2-Way Model ### The correct error term for the block interactions is the residual error,
behav.explor_mod<-lm(AUC ~ (Block + Light_Condition + Trtmt)^2, behav_dat)
anova(behav.explor_mod)


#Exploratory model to looking at 2-way and 3-way Block interactions   For 3-Way Model
behav.explor_mod_2<-lm(AUC ~ (Block + Light_Condition + Chem + Mech)^2 + Light_Condition:Chem:Mech, behav_dat)
anova(behav.explor_mod_2)


#Look at Blocks - Box plot
boxplot(AUC ~ Block, behav_dat, main = "The Effect of Block on Settlement",
        xlab="Block (Day)", ylab= "AUC of Settlement Percentage(over 24hrs)")
        
boxplot(AUC ~ Date, behav_dat, main = "The Effect of Block on Settlement",
        xlab="Block (Day)", ylab= "AUC of Settlement Percentage(over 24hrs)")





#### Probe Interaction - Figure out if doing main effect or simple effect analysis ####

## Partitioning the interaction SS(Perform Contrast Analysis) ##
#Contrast for Factor A - Light Condition B_H, B_L, D, G_H, G_L , R_H, R_L 

#(1)dark vs light      -1,-1,6,-1,-1,-1,-1
#(2)intensity          -1,1,0,-1,1,-1,1   
#(3)Reds vs nonreds    -1,-1,0,-1,-1,2,2
#(3)Blue vs nonblue    2,2,0,-1,-1,-1,-1
#(3)Green vs nongreen  -1,-1,0,2,2,-1,-1

#(4)int*Reds           1,-1,0,1,-1,-2,2
#(4)int*Blue           -2,2,0,1,-1,1,-1
#(4)int*Green           1,-1,0,-2,2,1,-1

#Reds
contrastmatrix_light <- cbind(c(-1,-1,6,-1,-1,-1,-1), c(-1,1,0,-1,1,-1,1), c(-1,-1,0,-1,-1,2,2),c(1,-1,0,1,-1,-2,2)) 
#Greens
contrastmatrix_light <- cbind(c(-1,-1,6,-1,-1,-1,-1), c(-1,1,0,-1,1,-1,1), c(-1,-1,0,2,2,-1,-1),c(1,-1,0,-2,2,1,-1)) 
#Blues
contrastmatrix_light <- cbind(c(-1,-1,6,-1,-1,-1,-1), c(-1,1,0,-1,1,-1,1), c( 2,2,0,-1,-1,-1,-1),c(-2,2,0,1,-1,1,-1)) 

str(behav_dat)

#Contrast for Factor B - chem=Ab Mech=Ab   Chem=pres; mech=Ab   Chem=Ab; Mech=pres   Chem=Pres; Mech=Pres
#Chem                 -1,1,-1,1
#Mech                 -1,-1,1,1
#chem*mech             1,-1,-1,1

#contrastmatrix_trtmt <- cbind(c(-1,1,-1,1), c(-1,-1,1,1), c(1,-1,-1,1))

#assign contrasts matricies 
contrasts(behav_dat$Light_Condition)<-contrastmatrix_light
#contrasts(behav_dat$Trtmt)<-contrastmatrix_trtmt

## Run Contrasts individually - not orthogonal ## 
#Red
#behav_con_mod<- aov(AUC ~ Light_Condition  + Block + Error(Light_Condition:Block) + Trtmt + Light_Condition:Trtmt, behav_dat)
#summary(behav_con_mod, split = list(Light_Condition= list("LvD" = 1, "Int" = 2, "RedVsOthers"=3, "Reds*Int"=4), Trtmt= list("Chem"=1, "Mech"=2, "Chem*Mech"=3)))
#Green
#behav_con_mod<- aov(AUC ~ Light_Condition  + Block + Error(Light_Condition:Block) + Trtmt + Light_Condition:Trtmt, behav_dat)
#summary(behav_con_mod, split = list(Light_Condition= list("LvD" = 1, "Int" = 2, "GreenVsOthers"=3, "Green*Int"=4), Trtmt= list("Chem"=1, "Mech"=2, "Chem*Mech"=3)))
#Blue
#behav_con_mod<- aov(AUC ~ Light_Condition  + Block + Error(Light_Condition:Block) + Trtmt + Light_Condition:Trtmt, behav_dat)
#summary(behav_con_mod, split = list(Light_Condition= list("LvD" = 1, "Int" = 2, "BlueVsOthers"=3, "Blue*Int"=4), Trtmt= list("Chem"=1, "Mech"=2, "Chem*Mech"=3)))


## Three way - split Dish Treatment (Chemical and Mechanical cues) up into their own factors ##
#Red
behav_con_mod<- aov(AUC ~ Light_Condition  + Block + Error(Light_Condition:Block) + Chem*Mech + Light_Condition*Chem*Mech, behav_dat)
summary(behav_con_mod, split = list(Light_Condition= list("LvD" = 1, "Int" = 2, "RedVsOthers"=3, "Reds*Int"=4)))

behav_con_mod<- aov(AUC ~  Block  + Light_Condition*Chem*Mech, behav_dat)
summary(behav_con_mod, split = list(Light_Condition= list("LvD" = 1, "Int" = 2, "RedVsOthers"=3, "Reds*Int"=4)))

#Green
behav_con_mod<- aov(AUC ~ Light_Condition  + Block + Error(Light_Condition:Block) + Chem*Mech + Light_Condition*Chem*Mech, behav_dat)
summary(behav_con_mod, split = list(Light_Condition= list("LvD" = 1, "Int" = 2, "GreenVsOthers"=3, "Green*Int"=4)))

behav_con_mod<- aov(AUC ~ Block + Light_Condition*Chem*Mech, behav_dat)
summary(behav_con_mod, split = list(Light_Condition= list("LvD" = 1, "Int" = 2, "GreenVsOthers"=3, "Green*Int"=4)))

#Blue
behav_con_mod<- aov(AUC ~ Light_Condition  + Block + Error(Light_Condition:Block) + Chem*Mech + Light_Condition*Chem*Mech, behav_dat)
summary(behav_con_mod, split = list(Light_Condition= list("LvD" = 1, "Int" = 2, "BlueVsOthers"=3, "Blue*Int"=4)))

behav_con_mod<- aov(AUC ~ Block + Light_Condition*Chem*Mech, behav_dat)
summary(behav_con_mod, split = list(Light_Condition= list("LvD" = 1, "Int" = 2, "BlueVsOthers"=3, "Blue*Int"=4)))



#### Run Light Questions on just A treatments since chem/mech cues highly influential and light is not playing a role in B-C #### 
#Subset Data 
sub_A<- subset(behav_dat, behav_dat$Trtmt  == "A")

#ANOVA - simple RCBD
A_mod<-lm(AUC ~ Block + Light_Condition, sub_A)
anova(A_mod)

#RESULTS
#Response: AUC
#                Df Sum Sq Mean Sq F value    Pr(>F)    
#Block            9 424.03  47.114  8.9415 4.197e-08 ***
#Light_Condition  6 131.23  21.871  4.1509  0.001685 ** 
#Residuals       54 284.53   5.269                      



#Contrasts
#Contrast for Light Condition B_H, B_L, D, G_H, G_L , R_H, R_L 

#(1)dark vs light      -1,-1,6,-1,-1,-1,-1
#(2)intensity          -1,1,0,-1,1,-1,1   
#(3)Reds vs nonreds    -1,-1,0,-1,-1,2,2
#(3)Blue vs nonblue    2,2,0,-1,-1,-1,-1
#(3)Green vs nongreen  -1,-1,0,2,2,-1,-1

#(4)int*Reds           1,-1,0,1,-1,-2,2
#(4)int*Blue           -2,2,0,1,-1,1,-1
#(4)int*Green           1,-1,0,-2,2,1,-1

#Reds
contrastmatrix_light_Red <- cbind(c(-1,-1,6,-1,-1,-1,-1), c(-1,1,0,-1,1,-1,1), c(-1,-1,0,-1,-1,2,2),c(1,-1,0,1,-1,-2,2)) 
#Greens
contrastmatrix_light_Green <- cbind(c(-1,-1,6,-1,-1,-1,-1), c(-1,1,0,-1,1,-1,1), c(-1,-1,0,2,2,-1,-1),c(1,-1,0,-2,2,1,-1)) 
#Blues
contrastmatrix_light_Blue <- cbind(c(-1,-1,6,-1,-1,-1,-1), c(-1,1,0,-1,1,-1,1), c( 2,2,0,-1,-1,-1,-1),c(-2,2,0,1,-1,1,-1)) 


#assign contrasts matricies 
contrasts(sub_A$Light_Condition)<-contrastmatrix_light_Red
contrasts(sub_A$Light_Condition)<-contrastmatrix_light_Green
contrasts(sub_A$Light_Condition)<-contrastmatrix_light_Blue

## Run Contrasts individually - not orthogonal ## 
#Red
A_con_mod<- aov(AUC ~ Light_Condition + Block, sub_A)
summary(A_con_mod, split = list(Light_Condition= list("LvD" = 1, "Int" = 2, "RedVsOthers"=3, "Reds*Int"=4)))

#Green
A_con_mod<- aov(AUC ~ Light_Condition + Block , sub_A)
summary(A_con_mod, split = list(Light_Condition= list("LvD" = 1, "Int" = 2, "GreenVsOthers"=3, "Green*Int"=4)))

#Blue
A_con_mod<- aov(AUC ~ Light_Condition + Block , sub_A)
summary(A_con_mod, split = list(Light_Condition= list("LvD" = 1, "Int" = 2, "BlueVsOthers"=3, "Blue*Int"=4)))





## Dunnents - Exploratory - not using in analysis 
A_mod_Dun<-lm(AUC ~ Block + Light_D, sub_A)
anova(A_mod_Dun)
library(multcomp)
test.dunnett=glht(A_mod_Dun,linfct=mcp(Light_D="Dunnett"))
confint(test.dunnett)


#Tukey - Exploratory - not using in analysis 
library(agricolae)

#Just A trtmt for light
light_comparison<-HSD.test(A_mod, "Light_Condition")

#three way
behav_mod_2.2<-lm(AUC ~ Block + Light_Condition*Chem*Mech, behav_dat) 
anova(behav_mod_2.2)
chem_comparison<-HSD.test(behav_mod_2.2, "Chem")
mech_comparison<-HSD.test(behav_mod_2.2, "Mech")
light_full_comparison<-HSD.test(behav_mod_2.2, "Light_Condition")

#two way
behav_mod_1.2<-lm(AUC ~ Block + Light_Condition + Trtmt + Light_Condition:Trtmt, behav_dat) 
anova(behav_mod_1.2)
trtmt_comparison<-HSD.test(behav_mod_1.2, "Trtmt")
light_full_2_comparison<-HSD.test(behav_mod_1.2, "Light_Condition")



#### Figures ####

## basic plots of full dataset to get an idea ##

#Light condition - Full Data
boxplot(AUC ~ Light_Condition, behav_dat, main = "The Effect of Light on Settlement",
        xlab="Light Condition", ylab= "AUC of Settlement Percentage(over 24hrs)")

#Chem/mechan trtmt - Full Data
boxplot(AUC ~ Trtmt, behav_dat, main = "The Effect of Chem/Mechan Trtmt on Settlement",
        xlab="Chem/Mech Trtmt", ylab= "AUC of Settlement Percentage(over 24hrs)")

#Chem/mech cues pulled out - Full Data
boxplot(AUC ~ Chem, behav_dat, main = "The Effect of Chemical cues on Settlement",
        xlab="Chem", ylab= "AUC of Settlement Percentage(over 24hrs)")

boxplot(AUC ~ Mech, behav_dat, main = "The Effect of Mechanical cues on Settlement",
        xlab="Mech", ylab= "AUC of Settlement Percentage(over 24hrs)")

boxplot(AUC ~ Chem*Mech, behav_dat, main = "The Effect of Chem*Mechanical cues on Settlement",
        xlab="Chem.Mech", ylab= "AUC of Settlement Percentage(over 24hrs)")

#Block
boxplot(AUC ~ Block, behav_dat, main = "The Effect of Block on Settlement",
        xlab="Block (Day)", ylab= "AUC of Settlement Percentage(over 24hrs)")


#The effect of light in treatment A 
boxplot(AUC ~ Light, A_dat, main = "The Effect of Light (int collapsed) on Settlement in Trtmt A",
        xlab="Block (Day)", ylab= "AUC of Settlement Percentage(over 24hrs)")




#interaction plots 
library(HH)
intxplot(AUC ~ Light_Condition, groups = Trtmt, data=behav_dat, se=TRUE, ylim=range(behav_dat$AUC),
         offset.scale=500)

intxplot(AUC ~ Trtmt, groups = Light_Condition, data=behav_dat, se=TRUE, ylim=range(behav_dat$AUC),
         offset.scale=500)

intxplot(AUC ~ Chem, groups = Mech, data=behav_dat, se=TRUE, ylim=range(behav_dat$AUC),
         offset.scale=500)

intxplot(AUC ~ Mech, groups = Chem, data=behav_dat, se=TRUE, ylim=range(behav_dat$AUC),
         offset.scale=500)

intxplot(AUC ~ Chem, groups = Light_Condition, data=behav_dat, se=TRUE, ylim=range(behav_dat$AUC),
         offset.scale=500)

intxplot(AUC ~ Mech, groups = Light_Condition, data=behav_dat, se=TRUE, ylim=range(behav_dat$AUC),
         offset.scale=500)

#looking at block effects --> really good interaction plots to use 
intxplot(AUC ~ Block, groups = Chem, data=behav_dat, se=TRUE, ylim=range(behav_dat$AUC),
         offset.scale=500)

intxplot(AUC ~ Block, groups = Mech, data=behav_dat, se=TRUE, ylim=range(behav_dat$AUC),
         offset.scale=500)


#Light v Mech and Chem
intxplot(AUC ~ Mech, groups = Light_Condition, data=behav_dat, se=TRUE, ylim=range(behav_dat$AUC),
         offset.scale=500)
intxplot(AUC ~ Chem, groups = Light_Condition, data=behav_dat, se=TRUE, ylim=range(behav_dat$AUC),
         offset.scale=500)

#A trtmts
intxplot(AUC ~ Block, groups = Light_Condition, data=behav_dat, se=TRUE, ylim=range(sub_A$AUC),
         offset.scale=500)

intxplot(AUC ~ Chem, groups = Light_Condition, data=behav_dat, se=TRUE, ylim=range(sub_A$AUC),
         offset.scale=500)

intxplot(AUC ~ Mech, groups = Light_Condition, data=behav_dat, se=TRUE, ylim=range(sub_A$AUC),
         offset.scale=500)


#Three - way interaction plot 
intxplot(Mech ~ Chem, groups = Light_Condition,data=behav_dat, ylim=range(behav_dat$AUC),
         offset.scale=500)





### Main Effect Plots ###

#Bar Graph of Total main effect of Trtmt

#first, get the means, by Soil type
mean.Yield <- tapply(behav_dat$AUC, list(behav_dat$Trtmt), mean) #then, get the standard deviations, by Soil type
sd.Yield <- tapply(behav_dat$AUC, list(behav_dat$Trtmt), sd) #finally, get the sample sizes, again by Soil type
n.Yield <- tapply(behav_dat$AUC, list(behav_dat$Trtmt), length) 
se.Yield <- sd.Yield/(n.Yield)**(1/2)
barplot(mean.Yield) #makes a simple barplot!
#Pimp your barplot
mids <- barplot(mean.Yield, beside = TRUE, legend = FALSE, main = "AUC of Settlement percentage of Trtmt", 
                xlab = "Trtmt",
                ylab = "AUC",
                ylim = c(0,20), col=grey(c(0.4,0.7,1)))
#now, to add error bars, we assign the barplot above to an object called "mids"
arrows(mids, mean.Yield - 2*se.Yield, mids, mean.Yield + 2*se.Yield, code = 3, angle = 90, length = 0.1)
#now add text, labeling the bars
text(mids, .5, paste(n.Yield), col=c("white", rep("black", 3)))


#Bar Graph of Total main effect of Light Condition

#first, get the means, by Soil type
mean.Yield <- tapply(behav_dat$AUC, list(behav_dat$Light_Condition), mean) #then, get the standard deviations, by Soil type
sd.Yield <- tapply(behav_dat$AUC, list(behav_dat$Light_Condition), sd) #finally, get the sample sizes, again by Soil type
n.Yield <- tapply(behav_dat$AUC, list(behav_dat$Light_Condition), length) 
se.Yield <- sd.Yield/(n.Yield)**(1/2)
barplot(mean.Yield) #makes a simple barplot!
#Pimp your barplot
mids <- barplot(mean.Yield, beside = TRUE, legend = FALSE, main = "AUC of Settlement percentage of Light Condition", 
                xlab = "Light_Condition",
                ylab = "AUC",
                ylim = c(0,20), col=grey(c(0.4,0.7,1)))
#now, to add error bars, we assign the barplot above to an object called "mids"
arrows(mids, mean.Yield - 2*se.Yield, mids, mean.Yield + 2*se.Yield, code = 3, angle = 90, length = 0.1)
#now add text, labeling the bars
text(mids, .5, paste(n.Yield), col=c("white", rep("black", 3)))



#Bar Graph of main effect of Light Condition - trtmt A

#first, get the means, by Soil type
mean.Yield <- tapply(A_dat$AUC, list(A_dat$Light_Condition), mean) #then, get the standard deviations, by Soil type
sd.Yield <- tapply(A_dat$AUC, list(A_dat$Light_Condition), sd) #finally, get the sample sizes, again by Soil type
n.Yield <- tapply(A_dat$AUC, list(A_dat$Light_Condition), length) 
se.Yield <- sd.Yield/(n.Yield)**(1/2)
barplot(mean.Yield) #makes a simple barplot!
#Pimp your barplot
mids <- barplot(mean.Yield, beside = TRUE, legend = FALSE, main = "The Effect of Light (Trtmt A) on AUC of Settlement percentage", 
                xlab = "Light Condition",
                ylab = "AUC",
                ylim = c(0,17), col=grey(c(0.4,0.7,1)))
#now, to add error bars, we assign the barplot above to an object called "mids"
arrows(mids, mean.Yield - 2*se.Yield, mids, mean.Yield + 2*se.Yield, code = 3, angle = 90, length = 0.1)
#now add text, labeling the bars
text(mids, .5, paste(n.Yield), col=c("white", rep("black", 3)))




### simple effect plots ###

#Subset data for simple effects analysis 
B_H_dat<-subset(behav_dat, behav_dat$Light_Condition == "Blue_High")
B_L_dat<-subset(behav_dat, behav_dat$Light_Condition == "Blue_Low")
G_H_dat<-subset(behav_dat, behav_dat$Light_Condition == "Green_High")
G_L_dat<-subset(behav_dat, behav_dat$Light_Condition == "Green_Low")
R_H_dat<-subset(behav_dat, behav_dat$Light_Condition == "Red_High")
R_L_dat<-subset(behav_dat, behav_dat$Light_Condition == "Red_Low")
Dk_dat<-subset(behav_dat, behav_dat$Light_Condition == "Dark_Control")

A_dat<-subset(behav_dat, behav_dat$Trtmt == "A")
B_dat<-subset(behav_dat, behav_dat$Trtmt == "B")
C_dat<-subset(behav_dat, behav_dat$Trtmt == "C")
D_dat<-subset(behav_dat, behav_dat$Trtmt == "D")


#Blue High
boxplot(AUC ~ Trtmt, B_H_dat, main = "The Effect of Chem/Mechan Trtmt on Settlement B_H",
        xlab="Chem/Mech Trtmt", ylab= "AUC of Settlement Percentage(over 24hrs)")

#Blue Low
boxplot(AUC ~ Trtmt, B_L_dat, main = "The Effect of Chem/Mechan Trtmt on Settlement B_L",
        xlab="Chem/Mech Trtmt", ylab= "AUC of Settlement Percentage(over 24hrs)")

#Green High
boxplot(AUC ~ Trtmt, G_H_dat, main = "The Effect of Chem/Mechan Trtmt on Settlement G_H",
        xlab="Chem/Mech Trtmt", ylab= "AUC of Settlement Percentage(over 24hrs)")

#Green Low
boxplot(AUC ~ Trtmt, G_L_dat, main = "The Effect of Chem/Mechan Trtmt on Settlement G_L",
        xlab="Chem/Mech Trtmt", ylab= "AUC of Settlement Percentage(over 24hrs)")

#Red High
boxplot(AUC ~ Trtmt, R_H_dat, main = "The Effect of Chem/Mechan Trtmt on Settlement R_H",
        xlab="Chem/Mech Trtmt", ylab= "AUC of Settlement Percentage(over 24hrs)")

#Red Low
boxplot(AUC ~ Trtmt, R_L_dat, main = "The Effect of Chem/Mechan Trtmt on Settlement R_L",
        xlab="Chem/Mech Trtmt", ylab= "AUC of Settlement Percentage(over 24hrs)")

#Dark
boxplot(AUC ~ Trtmt, Dk_dat, main = "The Effect of Chem/Mechan Trtmt on Settlement Dark ",
        xlab="Chem/Mech Trtmt", ylab= "AUC of Settlement Percentage(over 24hrs)")




#Chem/mechan trtmt A
boxplot(AUC ~ Light_Condition, A_dat, main = "The Effect of Light on Settlement for Trtmt A",
        xlab="Light Condition", ylab= "AUC of Settlement Percentage(over 24hrs)")

#Tukey
A_mod<-lm(AUC ~ Block + Light_Condition, A_dat)
trtmt_A<-HSD.test(A_mod, "Light_Condition")


#Chem/mechan trtmt B
boxplot(AUC ~ Light_Condition, B_dat, main = "The Effect of Light on Settlement for Trtmt B",
        xlab="Light Condition", ylab= "AUC of Settlement Percentage(over 24hrs)")
#Tukey
B_mod<-lm(AUC ~ Block + Light_Condition, B_dat)
trtmt_B<-HSD.test(B_mod, "Light_Condition")


#Chem/mechan trtmt C
boxplot(AUC ~ Light_Condition, C_dat, main = "The Effect of Light on Settlement for Trtmt C",
        xlab="Light Condition", ylab= "AUC of Settlement Percentage(over 24hrs)")

#Tukey
C_mod<-lm(AUC ~ Block + Light_Condition, C_dat)
anova(C_mod)
trtmt_C<-HSD.test(C_mod, "Light_Condition")

#Chem/mechan trtmt D
boxplot(AUC ~ Light_Condition, D_dat, main = "The Effect of Light on Settlement for Trtmt D",
        xlab="Light Condition", ylab= "AUC of Settlement Percentage(over 24hrs)")

#Tukey
D_mod<-lm(AUC ~ Block + Light_Condition, D_dat)
anova(D_mod)
trtmt_D<-HSD.test(D_mod, "Light_Condition")




## Line Graphs over Time ## 

#import data set 
behav_line_dat <- read.csv("~/Desktop/R /Actinula_Behavior_Summer_2020/line_graph_data_full_behav_7-27-20.csv")

behav_line_dat$Block<-as.factor(behav_line_dat$Block) 
behav_line_dat$Light_Condition<-as.factor(behav_line_dat$Light_Condition) 
str(behav_line_dat)

library("ggpubr")
#Total Data
ggline(behav_line_dat, x = "Time", y = "AUC", color = "Light_Condition",
       add = c("mean_se"), xlab="Time Point in Hours", ylab="AUC of Settlement Percentage",
       palette = c("steelblue2", "steelblue4","grey18","springgreen1","springgreen4", "tomato2","tomato4" ))

#Trtmt A
sub_A_line<-subset(behav_line_dat, behav_line_dat$Trtmt == "A")

ggline(sub_A_line, x = "Time", y = "AUC", color = "Light_Condition",
       add = c("mean_se"), xlab="Time Point in Hours", ylab="AUC of Settlement Percentage", main = "The Effect of Light over Time for Trtmt A on Settlement",
       palette = c("steelblue2", "steelblue4","grey18","springgreen1","springgreen4", "tomato2","tomato4" ))

#Trtmt B
sub_B_line<-subset(behav_line_dat, behav_line_dat$Trtmt == "B")

ggline(sub_B_line, x = "Time", y = "AUC", color = "Light_Condition",
       add = c("mean_se"), xlab="Time Point in Hours", ylab="AUC of Settlement Percentage",main = "The Effect of Light over Time for Trtmt B on Settlement",
       palette = c("steelblue2", "steelblue4","grey18","springgreen1","springgreen4", "tomato2","tomato4" ))

#Trtmt C
sub_C_line<-subset(behav_line_dat, behav_line_dat$Trtmt == "C")

ggline(sub_C_line, x = "Time", y = "AUC", color = "Light_Condition",
       add = c("mean_se"), xlab="Time Point in Hours", ylab="AUC of Settlement Percentage", main = "The Effect of Light over Time for Trtmt C on Settlement",
       palette = c("steelblue2", "steelblue4","grey18","springgreen1","springgreen4", "tomato2","tomato4" ))


#Trtmt D 
sub_D_line<-subset(behav_line_dat, behav_line_dat$Trtmt == "D")

ggline(sub_D_line, x = "Time", y = "AUC", color = "Light_Condition",
       add = c("mean_se"), xlab="Time Point in Hours", ylab="AUC of Settlement Percentage",main = "The Effect of Light over Time for Trtmt D on Settlement",
       palette = c("steelblue2", "steelblue4","grey18","springgreen1","springgreen4", "tomato2","tomato4" ))


#Blue High  
line_B_H_dat<-subset(behav_line_dat, behav_line_dat$Light_Condition == "Blue_High")

ggline(line_B_H_dat, x = "Time", y = "AUC", color = "Trtmt", main = "The Effect of Trtmt over Time in Blue Light/High Intensity on Settlement",
       add = c("mean_se"), xlab="Time Point in Hours", ylab="AUC of Settlement Percentage",
       palette = c("steelblue2","springgreen1", "snow4","palegreen4" ))

#Blue Low
line_B_L_dat<-subset(behav_line_dat, behav_line_dat$Light_Condition == "Blue_Low")

ggline(line_B_L_dat, x = "Time", y = "AUC", color = "Trtmt",main = "The Effect of Trtmt over Time in Blue Light/Low Intensity on Settlement",
       add = c("mean_se"), xlab="Time Point in Hours", ylab="AUC of Settlement Percentage",
       palette = c("steelblue2","springgreen1", "snow4","palegreen4" ))


#Green High
line_G_H_dat<-subset(behav_line_dat, behav_line_dat$Light_Condition == "Green_High")

ggline(line_G_H_dat, x = "Time", y = "AUC", color = "Trtmt",
       add = c("mean_se"), xlab="Time Point in Hours", ylab="AUC of Settlement Percentage", main = "The Effect of Trtmt over Time in Green Light/High Intensity on Settlement",
       palette = c("steelblue2","springgreen1", "snow4","palegreen4" ))


#Green Low
line_G_L_dat<-subset(behav_line_dat, behav_line_dat$Light_Condition == "Green_Low")

ggline(line_G_L_dat, x = "Time", y = "AUC", color = "Trtmt",
       add = c("mean_se"), xlab="Time Point in Hours", ylab="AUC of Settlement Percentage",main = "The Effect of Trtmt over Time in Green Light/Low Intensity on Settlement",
       palette = c("steelblue2","springgreen1", "snow4","palegreen4" ))


#Red High
line_R_H_dat<-subset(behav_line_dat, behav_line_dat$Light_Condition == "Red_High")

ggline(line_R_H_dat, x = "Time", y = "AUC", color = "Trtmt",
       add = c("mean_se"), xlab="Time Point in Hours", ylab="AUC of Settlement Percentage", main = "The Effect of Trtmt over Time in Red Light/High Intensity on Settlement",
       palette = c("steelblue2","springgreen1", "snow4","palegreen4" ))


#Red Low
line_R_L_dat<-subset(behav_line_dat, behav_line_dat$Light_Condition == "Red_Low")

ggline(line_R_L_dat, x = "Time", y = "AUC", color = "Trtmt",
       add = c("mean_se"), xlab="Time Point in Hours", ylab="AUC of Settlement Percentage", main = "The Effect of Trtmt over Time in Red Light/Low Intensity on Settlement",
       palette = c("steelblue2","springgreen1", "snow4","palegreen4" ))


#Dark
line_Dk_dat<-subset(behav_line_dat, behav_line_dat$Light_Condition == "Dark")

ggline(line_Dk_dat, x = "Time", y = "AUC", color = "Trtmt",
       add = c("mean_se"), xlab="Time Point in Hours", ylab="AUC of Settlement Percentage", main = "The Effect of Trtmt over Time in Darkness on Settlement",
       palette = c("steelblue2","springgreen1", "snow4","palegreen4" ))
