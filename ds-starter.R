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

ds.colnames("D")

ds.summary("D$AGE")

ds.summary("D$SEX")
