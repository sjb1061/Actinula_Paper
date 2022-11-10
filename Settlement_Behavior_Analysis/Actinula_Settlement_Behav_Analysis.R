# Actinula Settlement Behavior Analysis 

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


#The ANOVA - Three way (split-plot)
behav_mod_2<-aov(AUC ~ Light_Condition + Block + Error(Light_Condition:Block) + Light_Condition*Chem*Mech, behav_dat) 
summary(behav_mod_2)


## Probe Block Interactions ## 

#Exploratory model to looking at 2-way and 3-way Block interactions 
behav.explor_mod_2<-lm(AUC ~ (Block + Light_Condition + Chem + Mech)^2 + Light_Condition:Chem:Mech, behav_dat)
anova(behav.explor_mod_2)

#Interaction of Chem v Block
intxplot(AUC ~ Block, groups = Chem, data=behav_dat, se=TRUE, ylim=range(behav_dat$AUC),
         offset.scale=500)

#Interaction of Mech v Block
intxplot(AUC ~ Block, groups = Mech, data=behav_dat, se=TRUE, ylim=range(behav_dat$AUC),
         offset.scale=500)


#### Run Contrasts individually  #### 

#Contrast for Factor A = Light Condition: B_H, B_L, D, G_H, G_L , R_H, R_L 

#(1)dark vs light      -1,-1,6,-1,-1,-1,-1
#(2)intensity          -1,1,0,-1,1,-1,1   
#(3)Reds vs nonreds    -1,-1,0,-1,-1,2,2
#(3)Blue vs nonblue    2,2,0,-1,-1,-1,-1
#(3)Green vs nongreen  -1,-1,0,2,2,-1,-1

#(4)int*Reds           1,-1,0,1,-1,-2,2
#(4)int*Blue           -2,2,0,1,-1,1,-1
#(4)int*Green           1,-1,0,-2,2,1,-1


### Red ###
# Make matrix
contrastmatrix_light <- cbind(c(-1,-1,6,-1,-1,-1,-1), c(-1,1,0,-1,1,-1,1), c(-1,-1,0,-1,-1,2,2),c(1,-1,0,1,-1,-2,2)) 

#assign contrasts matrices 
contrasts(behav_dat$Light_Condition)<-contrastmatrix_light

#run Contrast - because this is a split plot, the Light condition section (individually) is incorrect 
#--> incorrect error term, see next group of contrasts for correct light condition section
behav_con_mod<- aov(AUC ~  Block  + Light_Condition*Chem*Mech, behav_dat)
summary(behav_con_mod, split = list(Light_Condition= list("LvD" = 1, "Int" = 2, "RedVsOthers"=3, "Reds*Int"=4)))


### Green ###
# Make matrix
contrastmatrix_light <- cbind(c(-1,-1,6,-1,-1,-1,-1), c(-1,1,0,-1,1,-1,1), c(-1,-1,0,2,2,-1,-1),c(1,-1,0,-2,2,1,-1)) 

#assign contrasts matrices
contrasts(behav_dat$Light_Condition)<-contrastmatrix_light

#run Contrast - because this is a split plot, the Light condition section (individually) is incorrect 
#--> incorrect error term, see next group of contrasts for correct light condition section
behav_con_mod<- aov(AUC ~ Block + Light_Condition*Chem*Mech, behav_dat)
summary(behav_con_mod, split = list(Light_Condition= list("LvD" = 1, "Int" = 2, "GreenVsOthers"=3, "Green*Int"=4)))


### Blue ###
# Make matrix
contrastmatrix_light <- cbind(c(-1,-1,6,-1,-1,-1,-1), c(-1,1,0,-1,1,-1,1), c( 2,2,0,-1,-1,-1,-1),c(-2,2,0,1,-1,1,-1)) 

#assign contrasts matrices
contrasts(behav_dat$Light_Condition)<-contrastmatrix_light

#run Contrast - because this is a split plot, the Light condition section (individually) is incorrect 
#--> incorrect error term, see next group of contrasts for correct light condition section
behav_con_mod<- aov(AUC ~ Block + Light_Condition*Chem*Mech, behav_dat)
summary(behav_con_mod, split = list(Light_Condition= list("LvD" = 1, "Int" = 2, "BlueVsOthers"=3, "Blue*Int"=4)))



#### Run Light Questions on just A treatments = light cues #### 
#Subset Data 
sub_A<- subset(behav_dat, behav_dat$Trtmt  == "A")

#ANOVA - simple RCBD
A_mod<-lm(AUC ~ Block + Light_Condition, sub_A)
anova(A_mod)

#Contrast for Light Condition B_H, B_L, D, G_H, G_L , R_H, R_L 

#(1)dark vs light      -1,-1,6,-1,-1,-1,-1
#(2)intensity          -1,1,0,-1,1,-1,1   
#(3)Reds vs nonreds    -1,-1,0,-1,-1,2,2
#(3)Blue vs nonblue    2,2,0,-1,-1,-1,-1
#(3)Green vs nongreen  -1,-1,0,2,2,-1,-1

#(4)int*Reds           1,-1,0,1,-1,-2,2
#(4)int*Blue           -2,2,0,1,-1,1,-1
#(4)int*Green           1,-1,0,-2,2,1,-1


### Red ###
# Make matrix
contrastmatrix_light_Red <- cbind(c(-1,-1,6,-1,-1,-1,-1), c(-1,1,0,-1,1,-1,1), c(-1,-1,0,-1,-1,2,2),c(1,-1,0,1,-1,-2,2)) 

#assign contrasts matrices
contrasts(sub_A$Light_Condition)<-contrastmatrix_light_Red

#run Contrast (only the individual light condition portion is correct - other part has incorrect error term)
A_con_mod<- aov(AUC ~ Light_Condition + Block, sub_A)
summary(A_con_mod, split = list(Light_Condition= list("LvD" = 1, "Int" = 2, "RedVsOthers"=3, "Reds*Int"=4)))


### Green ###
# Make matrix
contrastmatrix_light_Green <- cbind(c(-1,-1,6,-1,-1,-1,-1), c(-1,1,0,-1,1,-1,1), c(-1,-1,0,2,2,-1,-1),c(1,-1,0,-2,2,1,-1)) 

#assign contrasts matrices
contrasts(sub_A$Light_Condition)<-contrastmatrix_light_Green

#run Contrast (only the individual light condition portion is correct - other part has incorrect error term)
A_con_mod<- aov(AUC ~ Light_Condition + Block , sub_A)
summary(A_con_mod, split = list(Light_Condition= list("LvD" = 1, "Int" = 2, "GreenVsOthers"=3, "Green*Int"=4)))


### Blue ###
# Make matrix
contrastmatrix_light_Blue <- cbind(c(-1,-1,6,-1,-1,-1,-1), c(-1,1,0,-1,1,-1,1), c( 2,2,0,-1,-1,-1,-1),c(-2,2,0,1,-1,1,-1)) 

#assign contrasts matrices
contrasts(sub_A$Light_Condition)<-contrastmatrix_light_Blue

#run Contrast (only the individual light condition portion is correct - other part has incorrect error term)
A_con_mod<- aov(AUC ~ Light_Condition + Block , sub_A)
summary(A_con_mod, split = list(Light_Condition= list("LvD" = 1, "Int" = 2, "BlueVsOthers"=3, "Blue*Int"=4)))



####### Figures #######



#### Box plots of Individual cue effects ####
library(ggplot2)

## Fig 2.B - Light Cues (light vs Dark) 
  #Subset data for light presence abscence then plot
sub_A<- subset(behav_dat, behav_dat$Trtmt  == "A")
ggplot(sub_A, aes(x=LvD, y=AUC, fill=LvD)) + geom_boxplot()  + theme_classic() + labs(x="\n Light Cues", y = "AUC of Settlement Percentage (over 24hrs)\n") +guides(fill=guide_legend(title="Light Cue")) + theme(axis.text=element_text(size=rel(2)), plot.margin=margin(1.5,1.5,1.5,1.5,"cm"), legend.key.size=unit(2.5,"cm"),axis.title=element_text(size=20),legend.text=element_text(size=15), legend.title=element_text(size=17))

## Fig 2.C - Chem Cues (Presence vs Abscence) 
  #Subset data for only chem cue presence and absence then plot
sub_ab <- subset(behav_dat, Trtmt!="C" & Trtmt!="D")
ggplot(sub_ab, aes(x=Chem_Plot, y=AUC, fill=Chem_Plot)) + geom_boxplot() + theme_classic() + labs(x="\n Chemical Cues", y = "AUC of Settlement Percentage (over 24hrs)\n") +guides(fill=guide_legend(title="Chemical Cue")) +theme(axis.text=element_text(size=rel(2)), plot.margin=margin(1.5,1.5,1.5,1.5,"cm"), legend.key.size=unit(2.5,"cm"),axis.title=element_text(size=20),legend.text=element_text(size=15), legend.title=element_text(size=17))

## Fig 2.D - Mech Cues (Presence vs Abscence) 
  #Subset data for only mech cue presence and absence then plot
sub_ac <- subset(behav_dat, Trtmt!="B" & Trtmt!="D")
ggplot(sub_ac, aes(x=Mech_Plot, y=AUC, fill=Mech_Plot)) + geom_boxplot() + theme_classic() + labs(x="\n Mechanical Cues", y = "AUC of Settlement Percentage (over 24hrs)\n") +guides(fill=guide_legend(title="Mechanical Cue")) + theme(axis.text=element_text(size=rel(2)), plot.margin=margin(1.5,1.5,1.5,1.5,"cm"), legend.key.size=unit(2.5,"cm"),axis.title=element_text(size=20),legend.text=element_text(size=15), legend.title=element_text(size=17))



#### Box plots of the seven light conditions across all treatments ####
library(ggplot2)

## Fig 2.E - The Effect of the Seven Light Conditions on Settlement
A_dat<-subset(behav_dat, behav_dat$Trtmt == "A")

ggplot(A_dat, aes(x=Light_Condition, y=AUC, fill=Light_Condition)) + geom_boxplot() + 
  theme_classic() + 
  labs(x="Light Condition", y = "AUC of Settlement Percentage (over 24hrs)\n") +
  guides(fill=guide_legend(title="Light Condition Key")) + 
  theme(axis.text=element_text(size=rel(2)), plot.margin=margin(1.5,1.5,1.5,1.5,"cm"), legend.key.size=unit(1.5,"cm"),
        axis.title=element_text(size=20),axis.text.x = element_text(angle = 45, hjust=1), legend.text=element_text(size=15), legend.title=element_text(size=17)) +
  scale_fill_manual(values=c("#3498DB","#21618C","#17202A","#27AE60","#196F3D","#E74C3C","#943126"))


## Fig 2.F - The Effect of Chemical Cues across Seven Light Conditions 
B_dat<-subset(behav_dat, behav_dat$Trtmt == "B")

ggplot(B_dat, aes(x=Light_Condition, y=AUC, fill=Light_Condition)) + geom_boxplot() + 
  theme_classic() + 
  labs(x="Light Condition", y = "AUC of Settlement Percentage (over 24hrs)\n") +
  guides(fill=guide_legend(title="Light Condition Key")) + 
  theme(axis.text=element_text(size=rel(2)), plot.margin=margin(1.5,1.5,1.5,1.5,"cm"), legend.key.size=unit(1.5,"cm"),
        legend.title=element_text(size=17),axis.title=element_text(size=20),axis.text.x = element_text(angle = 45, hjust=1),legend.text=element_text(size=15) ) +
  scale_fill_manual(values=c("#3498DB","#21618C","#17202A","#27AE60","#196F3D","#E74C3C","#943126"))


## Fig 2.G - The Effect of Mechanical Cues across Seven Light Conditions
C_dat<-subset(behav_dat, behav_dat$Trtmt == "C")

ggplot(C_dat, aes(x=Light_Condition, y=AUC, fill=Light_Condition)) + geom_boxplot() + 
  theme_classic() + 
  labs(x="Light Condition", y = "AUC of Settlement Percentage (over 24hrs)\n") +
  guides(fill=guide_legend(title="Light Condition Key")) + 
  theme(axis.text=element_text(size=rel(2)), plot.margin=margin(1.5,1.5,1.5,1.5,"cm"), legend.key.size=unit(1.5,"cm"),
        legend.title=element_text(size=17),axis.title=element_text(size=20),axis.text.x = element_text(angle = 45, hjust=1),legend.text=element_text(size=15)) +
  scale_fill_manual(values=c("#3498DB","#21618C","#17202A","#27AE60","#196F3D","#E74C3C","#943126"))


## Fig 2.H - The Effect of Chemical and Mechanical Cues Combined across Seven Light Conditions
D_dat<-subset(behav_dat, behav_dat$Trtmt == "D")

ggplot(D_dat, aes(x=Light_Condition, y=AUC, fill=Light_Condition)) + geom_boxplot() + 
  theme_classic() + 
  labs(x="Light Condition", y = "AUC of Settlement Percentage (over 24hrs)\n") +
  guides(fill=guide_legend(title="Light Condition Key")) + 
  theme(axis.text=element_text(size=rel(2)), plot.margin=margin(1.5,1.5,1.5,1.5,"cm"), legend.key.size=unit(1.5,"cm"),
        legend.title=element_text(size=17),axis.title=element_text(size=20),axis.text.x = element_text(angle = 45, hjust=1),legend.text=element_text(size=15)) +
  scale_fill_manual(values=c("#3498DB","#21618C","#17202A","#27AE60","#196F3D","#E74C3C","#943126"))



#### Interaction Plots ####
library(HH)

## Fig 2.I - Interaction (two-way): Chem cues vs Light cues
par.settings<- simpleTheme(col=c("#3498DB","#21618C","#17202A","#27AE60","#196F3D","#E74C3C","#943126"), lwd=6)
intxplot(AUC ~ Chem_Plot, groups = Light_Condition, data=sub_ab, se=TRUE, ylim=range(behav_dat$AUC), par.settings=par.settings,
         offset.scale=500, main="Two-Way Interaction Plot: Chemical Cues vs Light Cues",
         xlab="\n Chemical Cue Presence/Absence",ylab="AUC of Settlement Percentage (over 24hrs)\n",main.cex=2, lab.cex=1.5)


## Fig 2.J - Interaction (two-way): Mech cues vs Light cues
par.settings<- simpleTheme(col=c("#3498DB","#21618C","#17202A","#27AE60","#196F3D","#E74C3C","#943126"), lwd=6)
intxplot(AUC ~ Mech_Plot, groups = Light_Condition, data=sub_ac, se=TRUE, ylim=range(behav_dat$AUC), par.settings=par.settings,
         offset.scale=500, main="Two-Way Interaction Plot: Mechanical Cues vs Light Cues",
         xlab="\n Mechanical Cue Presence/Absence",ylab="AUC of Settlement Percentage (over 24hrs)\n",main.cex=2, lab.cex=1.5)


## Fig 2.K - Interaction (two-way): Chem cues vs Mech cues
par.settings<- simpleTheme(col=c("#D9717D","#4DB6D0"), lwd=6)
intxplot(AUC ~ Mech_Plot, groups = Chem_Plot, data=behav_dat, se=TRUE, ylim=range(behav_dat$AUC),par.settings=par.settings,
         offset.scale=500, main="Two-Way Interaction Plot: Mechanical Cues vs Chemical Cues",xlab="\n Mechanical Cue Presence/Absence",
         ylab="AUC of Settlement Percentage (over 24hrs)\n", main.cex=2, lab.cex=1.5)


## Fig 2.L - Interaction (three-way): Chem cues vs Light cues vs Mech cues
par.settings<- simpleTheme(col=c("#3498DB","#21618C","#17202A","#27AE60","#196F3D","#E74C3C","#943126"), lwd=6)
intxplot(AUC ~ Trtmt, groups = Light_Condition, data=behav_dat, se=TRUE, ylim=range(behav_dat$AUC), par.settings=par.settings,
         offset.scale=500,main=" ",xlab="\n Treatments",
         ylab="AUC of Settlement Percentage (over 24hrs)\n",lab.cex=2) 


