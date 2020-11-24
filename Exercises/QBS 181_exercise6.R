# Exercise 6
# Phillip Schuld f0040sz

# setting up RODBC drivers for database connection through R
library(RODBC)
library(dplyr)
library(stringr)
library(tidyr)
library(lubridate)

# open connection to database
myConn <- odbcConnect("qbs 181", "pschuld",
                      "pschuld@qbs181")

# save tables to data frame objects in R
demo <- sqlQuery(myConn, "select * from Demographics")
phone <- sqlQuery(myConn, "select * from Phonecall")
encounters <- sqlQuery(myConn, "select * from Encounters")
provider <- sqlQuery(myConn, "select * from Provider")
procedure <- sqlQuery(myConn, "select * from Procedure")

# 1)
demo$tri_age[is.na(demo$tri_age)] <- mean(demo$tri_age, na.rm = TRUE)

# 2)
# convert call start time to datetime object
phone$CallStartTime <- as.POSIXct(phone$CallStartTime, format="%m/%d/%y %H:%M %p")
# calculated call end time column from start time and call duration
phone <- phone %>%
  mutate(CallEndTime = CallStartTime + CallDuration)

# 3)
# I)
# could not access procedure table from RODBC
# II)
# convert from factors to dates
encounters$NEW_HSP_ADMIT_DATE <- as.character(encounters$NEW_HSP_ADMIT_DATE)
encounters$NEW_HSP_ADMIT_DATE <- as.POSIXct(encounters$NEW_HSP_ADMIT_DATE, format="%m/%d/%Y")
encounters$NEW_HSP_DISCH_DATE <- as.character(encounters$NEW_HSP_DISCH_DATE)
encounters$NEW_HSP_DISCH_DATE <- as.POSIXct(encounters$NEW_HSP_DISCH_DATE, format="%m/%d/%Y")

encounters <- dplyr::inner_join(encounters, provider, by = c("NEW_VISIT_PROV_ID" = "NEW_PROV_ID"))

encounters <- encounters %>%
  mutate(StayDuration = NEW_HSP_DISCH_DATE - NEW_HSP_ADMIT_DATE)

# remove na stay duration rows
encounters <- encounters[!is.na(encounters$StayDuration),]

encounters <- encounters %>%
  dplyr::arrange(desc(StayDuration))
