
# This script prepares a dataset based on the Swiss Household Panel survey
# https://forscenter.ch/projects/swiss-household-panel/

# Set working directory:
setwd("~/Documents/SHP")

library(stringr)

DATA_covid <-
  haven::read_dta("swissubase_932_7_0/Data_STATA/SHP_Covid_STATA/shp_covid_user.dta")

DATA_h <-
    haven::read_dta("swissubase_932_7_0/Data_STATA/SHP-Data-W1-W21-STATA/W21_2019/shp19_h_user.dta")

DATA_p <-
  haven::read_dta("swissubase_932_7_0/Data_STATA/SHP-Data-W1-W21-STATA/W21_2019/shp19_p_user.dta")

DATA_CNEF2019 <-
  haven::read_dta("swissubase_932_7_0/Data_STATA/SHP-Data-CNEF-STATA/shpequiv_2019.dta")

DATA_wealth <-
  haven::read_dta("swissubase_932_7_0/Data_STATA/SHP-Data-Imputed-Income-Wealth-STATA/imputed_income_pers_wide_shp.dta")


# Merge dataframes:
DATA <- merge(DATA_p,DATA_covid,by='idpers')

names(DATA_wealth)[which(str_detect(names(DATA_wealth),"ptotn"))]

DATA <- merge(DATA,DATA_wealth,by='idpers')
save(DATA,file="output/SHP.Rdat")

# allnames <- names(DATA)
# subs <- "adul"
# indic <- which(grepl(subs,allnames))
# allnames[indic]

library(labelled) # allows to get labels of variables

sink(file = "output/variables.txt")
var_label(DATA)
sink()


