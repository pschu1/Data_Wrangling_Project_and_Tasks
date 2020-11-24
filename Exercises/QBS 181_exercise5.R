# Exercise 5
# Phillip Schuld f0040sz

# setting up RODBC drivers for database connection through R
library(RODBC)
library(dplyr)
library(stringr)
library(tidyr)

# open connection to database
myConn <- odbcConnect("qbs 181", "pschuld",
                      "pschuld@qbs181")

# save tables to data frame objects in R
flow <- sqlQuery(myConn, "select * from Flowsheets")
provider <- sqlQuery(myConn, "select * from Provider")

# 1)
flow$DISP_NAME <- gsub("cc/kg", "CC-Kg", flow$DISP_NAME)
# 2)
flow_spaces <- sapply(flow, function(x) gsub(pattern = "[[:alnum:]]", replacement = " ", flow[1:10,]))
flow_spaces <- sapply(flow, function(x) gsub(pattern = "[[:punct:]]", replacement = " ", flow_spaces))

# 3)
# separate name column into two columns at the space
provider <- provider %>%
  separate(
    NEW_PROV_NAME,
    into = c("Last Name", "First Name"),
    sep = " ",
    remove = TRUE,
    convert = FALSE,
  )

# remove commas in last name column
provider$`Last Name` <- str_remove_all(provider$`Last Name`, ",")

# extract last names that begin with WA
grep("^Wa", provider$`Last Name`, value = TRUE)


