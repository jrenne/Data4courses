# ==============================================================================
# Microeconometrics course
# Jean-Paul Renne, HEC Lausanne
# ==============================================================================
# This script prepares a small dataset to be used to illustrate courses
# ==============================================================================

# Clear environment and console
rm(list = ls(all = TRUE)) # clear environment 
cat("\014") # clear console

# Set working directory:
setwd("~/Dropbox/Teaching/Databases/HRS_RAND/Prepare_small_datasets")

# Load the dataset
load("../HRSdataset.Rdat")

# Dimension of the database:
dim(HRS) # number of rows = number of households

# Labels:
names(HRS)

# Process variables that are not time-dependent:
HRS$rfemale <- 1*(HRS$ragender==2)

# Process variables that are time-dependent (14 waves):
for(i in 1:14){# loop on waves
  string_of_characters <- paste("HRS$rretired_Y",i," <- 1*(HRS$rlbrf_Y",i,"==5)",sep="")
  eval(parse(text=string_of_characters))
  
  string_of_characters <- paste("HRS$rdisable_Y",i," <- 1*(HRS$rlbrf_Y",i,"==6)",sep="")
  eval(parse(text=string_of_characters))
  
  string_of_characters <- paste("HRS$rnotmar_Y",i," <- 1*(HRS$rmstat_Y",i,">=3)",sep="")
  eval(parse(text=string_of_characters))
  
  string_of_characters <- paste("HRS$rworkft_Y",i," <- 1*(HRS$rlbrf_Y",i,"==1)",sep="")
  eval(parse(text=string_of_characters))
  
  string_of_characters <- paste("HRS$rworkpt_Y",i," <- 1*(HRS$rlbrf_Y",i,"==2)",sep="")
  eval(parse(text=string_of_characters))
}

# Add labels:
# (i) variables that are not time-dependent:
HRS$rfemale <- haven::labelled(HRS$rfemale,c("No"=0,"Yes"=1),label = c("Female?"))
# (ii) variables that are time-dependent:
Strings <- c("rretired_Y","rdisable_Y","rnotmar_Y","rworkft_Y","rworkpt_Y")
Label_title <- c("Retired?","Disabled?","Not married?","Work full time?","Work part time?")
count <- 0
for(variable in Strings){
  count <- count + 1
  for(i in 1:14){
    string_of_characters <- paste("HRS$",variable,i,"<- haven::labelled(HRS$",variable,i,",c('No'=0,'Yes'=1),label = c('",Label_title[count],"'))",sep="")
    eval(parse(text=string_of_characters))
  }
}

myvars <- c("hhidpn", # household index
            "rfemale", # "is female?"
            "riearn_Y14", # earnings
            "raedyrs", # years of education
            "radla_Y14", # has some diffculties in adls (activities of daily living)
            "rsmokev_Y14", # smoke ever
            "rsmoken_Y14", # currently smokes
            "ragey_b_Y14", # age
            "rlbrf_Y14" # labour force status
            )

# Reduce dataset:
reducedHRS <- as.data.frame(HRS[myvars])

names(reducedHRS) <- gsub("_Y14","",names(reducedHRS))

# Keep only people that work FT:
reducedHRS <- subset(reducedHRS,rlbrf==1)

# Remove very high salaries:
reducedHRS <- subset(reducedHRS,riearn<500000)

# Keep only lines with complete data:
reducedHRS <- reducedHRS[complete.cases(reducedHRS),]


# save csv file:
write.csv(reducedHRS,file="reducedHRS.csv", row.names=FALSE)

eq <- lm(riearn~raedyrs+ragey_b+I(ragey_b^2),data=reducedHRS)
print(summary(eq))

plot(riearn~ragey_b,data=reducedHRS)
