
# Prepare initial dataset:

# Set working directory:
setwd("~/Dropbox/Teaching/Microeconometrics/Databases/HRS_RAND")

# Read the (stata-format) database, using the "haven" package:
DATA <- haven::read_dta("randhrs1992_2018v1.dta")

# Create a text file containing the variables' labels:
library(labelled) # allows to get labels of variables
save_opt <- getOption("max.print")
options(max.print=1000000)
sink(file = "variables_HRS.txt")
var_label(DATA)
sink()
options(max.print=save_opt)


# Detect variables containing subtring:
allnames <- names(DATA)
subs <- "edyr"
indic <- which(grepl(subs,allnames))
allnames[indic]

# This vector will contain the names of the variables, with the same name format as
#    in the original database:
variable2keep <- c("hhidpn","ragender","raracem","rabyear","raedyrs")

# This vector will contain the names of the variables, but the wave index will
#    be given at the end of the variable name:
variable2keep_withprefix <- c("hhidpn","ragender","raracem","rabyear","raedyrs")

matrix_prefix_suffix <- rbind(
  c("inw",""),
  c("h","hhres"),
  c("h","inpov"),
  c("r","mstat"),
  c("r","lbrf"),
  c("r","agey_b"),
  c("s","agey_b"),
  c("r","bmi"),
  c("s","bmi"),
  c("r","doctor"),
  c("s","doctor"),
  c("r","doctim"),
  c("s","doctim"),
  c("r","smokev"),
  c("s","smokev"),
  c("r","smoken"),
  c("s","smoken"),
  c("r","shlt"),
  c("r","adla"),
  c("r","higov"),
  c("r","covr"),
  c("r","covrt"),
  c("r","work"),
  c("r","work2"),
  c("h","itot"),
  c("r","iearn"),
  c("r","jhours"),
  c("r","wgihr"),
  c("r","wgiwk"),
  c("r","oopmd"),
  c("r","totmbi")
)


# Build all possible variable names:
last <- 14

for(i in 1:dim(matrix_prefix_suffix)[1]){
  for(j in 1:last){
    variable2keep <- c(variable2keep,
                       paste(matrix_prefix_suffix[i,1],j,matrix_prefix_suffix[i,2],sep=""))
    variable2keep_withprefix <- c(variable2keep_withprefix,
                                  paste(matrix_prefix_suffix[i,1],matrix_prefix_suffix[i,2],"_Y",j,sep=""))
  }
}

variable2keep_withprefix <- variable2keep_withprefix[variable2keep %in% names(DATA)]
variable2keep            <- variable2keep[variable2keep %in% names(DATA)]

DATA_reduced <- subset(DATA,select=variable2keep)
names(DATA_reduced) <- variable2keep_withprefix

HRS <- DATA_reduced

# Save data in Rdat format:
save(HRS,file="HRSdataset.Rdat")




