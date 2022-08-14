
data <- read.csv("~/Dropbox/Teaching/Data4courses/Credit/Credit.csv")
names(data)

data$issue_Y <- as.integer(substr(data$issue_d,5,6))

#loanData$issue_Y <- format(data$issue_d,"%Y")

data <- subset(data,
               (issue_Y==10)&
                 (!is.na(int_rate))&
                 (term==" 36 months"))

# Detect series that are filled enough:
variables.ok <- which(apply(data,2,function(x){sum(is.na(x))})<.25*dim(data)[1])
data <- data[,variables.ok]

data$revol_util <- as.numeric(sub("%","",data$revol_util))

plot(density(data$int_rate))

data$emp_length_10 <- data$emp_length %in% c("5 years","6 years","7 years",
                                             "8 years","9 years","10+ years")

summary(lm(int_rate ~ delinq_2yrs + I(log(annual_inc)) + dti + installment +
             verification_status + I(log(funded_amnt)) + pub_rec +
             emp_length_10 + home_ownership + pub_rec_bankruptcies + revol_util + 
             revol_bal + addr_state,
           data=data))


save(data,file="credit.rda")
