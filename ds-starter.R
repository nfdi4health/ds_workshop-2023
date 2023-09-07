# Install dsBaseClient and dependencies if not already done
#install.packages('dsBaseClient', repos=c(getOption('repos'), 'https://cran.obiba.org'))

# Load DataSHIELD base package
library(dsBaseClient)

builder <- DSI::newDSLoginBuilder()
builder$append(server="server1", url="https://dsmolep.mdc-berlin.de",
               user="tester", password="Te$ter21",
               table = "Test.harmonized_study_TEST_table_TEST")
logindata <- builder$build()


# Then perform login in each server
library(DSOpal)
connections <- datashield.login(logins=logindata, assign = T)

# Administrative functions
ds.listClientsideFunctions()
ds.listServersideFunctions()
ds.listDisclosureSettings()
ds.listOpals()


# Data Analysis functions (generally of type "Aggregate")
## Data structure queries
ds.class("D$AGE")

ds.class("D$SEX")
ds.levels("D$SEX")

ds.class("D$SMOKE_ST")
ds.levels("D$SEX")

ds.class("D$SOD_POT")

## Summary Statistics Functions
ds.summary("D$AGE")
ds.summary("D$SEX")
ds.summary("D$SMOKE_ST")
ds.summary("D$SOD_POT") # we can show how this can be automated with datashieldDescriptives

