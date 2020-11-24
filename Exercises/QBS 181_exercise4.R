# Exercise 4
# Phillip Schuld f0040sz

# setting up RODBC drivers for database connection through R
library(RODBC)
library(dplyr)
library(stringr)

# open connection to database
myConn <- odbcConnect("qbs 181", "pschuld",
                      "pschuld@qbs181")

# save tables to data frame objects in R
dx <- sqlQuery(myConn, "select * from Dx")
inpatient <- sqlQuery(myConn, "select * from Inpatient")
outpatient <- sqlQuery(myConn, "select * from Outpatient")

# 1)
# note: there is no column called 'disp_name' as mentioned in the assignment
# changing DX_NAME column instead
# column name to lower case
colnames(dx)[which(names(dx) == "DX_NAME")] <- tolower(colnames(dx)[which(names(dx) == "DX_NAME")])
# column contents to lower case
dx$dx_name <- tolower(dx$dx_name)

# 2)
# remove commas
dx$dx_name <- str_remove_all(dx$dx_name, ",")
# remove whitespace
dx$dx_name <- str_trim(dx$dx_name, "both")

# 3)
# remove hyphens
inpatient$NEW_PATIENT_DHMC_MRN <- str_remove(inpatient$NEW_PATIENT_DHMC_MRN, "-")
outpatient$NEW_PATIENT_DHMC_MRN <- str_remove(outpatient$NEW_PATIENT_DHMC_MRN, "-")
# merge
in_out_patient <- dplyr::inner_join(inpatient, outpatient, by = "NEW_PATIENT_DHMC_MRN")

# 4)
in_out_patient_2 <- dplyr::inner_join(inpatient, outpatient, by = "NEW_PAT_ID")
# test if sets of NEW_PATIENT_DHMC_MRN are the same in both data frames
unique(in_out_patient$NEW_PATIENT_DHMC_MRN) == unique(in_out_patient_2$NEW_PATIENT_DHMC_MRN)
