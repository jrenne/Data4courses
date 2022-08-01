#
# Linear regressions
#

setwd("~/Dropbox/Teaching/Data4courses/parapluie")

# Load data:
Google         <- read.csv("google_trend_parapluie.csv")
Precipitations <- read.csv("xls_Climatologie1104.csv")

Google$Semaine <- substr(Google$Semaine,1,10)
Google$Semaine <- as.Date(Google$Semaine,"%Y-%m-%d")
Google$mois    <- as.integer(format(Google$Semaine,"%m"))
Google$annee   <- as.integer(format(Google$Semaine,"%Y"))

Precipitations$Mois   <- as.Date(Precipitations$Mois,"%d/%m/%y")
Precipitations$precip <- apply(Precipitations[,2:7],1,mean)

All.data <- data.frame(date = Precipitations$Mois,precip=Precipitations$precip)
N <- dim(All.data)[1]

# Add variable "parapluie" (Google) in All.data
All.data$parapluie <- NaN
count <- 0
for(a in 2005:2010){
  for(m in 1:12){
    count <- count + 1
    data.aux <- subset(Google,(annee==a)&(mois==m))
    All.data$parapluie[count] <- mean(as.integer(data.aux$parapluie))
  }
}

# Remove trend from Google data:
trend <- 1:N
eq.trend <- lm(All.data$parapluie~trend)
detrend.parapluie <- eq.trend$residuals
All.data$parapluie <- detrend.parapluie

eq <- lm(All.data$parapluie~All.data$precip)
summary((eq))

plot(All.data$date,All.data$parapluie,type='l')
lines(All.data$date,eq$fitted.values,col='red')

write.csv(All.data,file="../data4parapluie.csv",row.names=FALSE)

stop()


# Construct monthly dummies:
monthly.dummy <- matrix(0,N,11)
for(i in 1:11){
  aux <- rep(0,12)
  aux[i] <- 1
  aux <- rep(aux,10)
  aux <- aux[1:N]
  monthly.dummy[,i] <- aux
}

# Deseasonalize series:
eq.deseas <- lm(All.data$parapluie~monthly.dummy)
All.data$deseas.parapluie <- eq.deseas$residuals

eq.deseas <- lm(All.data$precip~monthly.dummy)
All.data$deseas.precip <- eq.deseas$residuals


# Illustrate the Frisch Waugh theorem ######
# ================


# Regress parapluie on precip:
eq <- lm(parapluie~precip,data=All.data)
print(summary(eq))

# Regress parapluie on precip (deseasonalized):
eq <- lm(deseas.parapluie~deseas.precip,data=All.data)
print(summary(eq))

# Regress parapluie on precip + dummies:
eq <- lm(parapluie~precip+monthly.dummy,data=All.data)
print(summary(eq))

plot(All.data$nb.deces,type="l")
par(new=TRUE)
plot(All.data$precip,type="l",col="red")



