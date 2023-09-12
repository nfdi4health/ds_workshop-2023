# Install DataSHIELD packages and dependencies if not already done
install.packages('DSI')
install.packages('DSOpal', dependencies=TRUE)
install.packages('dsBaseClient', repos=c(getOption('repos'), 'https://cran.obiba.org'))

# Load DataSHIELD libraries
library(DSI)
library(DSOpal)
library(dsBaseClient)


builder <- DSI::newDSLoginBuilder()
builder$append(server="ActivE", url="https://dsmolep.mdc-berlin.de",
               user=readline("Input username: "),
               password=readline("Input password: "),
               table = "Test.harmonized_study_TEST_table_TEST")
# builder$append(server="EPIC-Potsdam", url="",
#                user=readline("Input username: "),
#                password=readline("Input password: "),
#                table = "")

logindata <- builder$build()


# Then perform login in each server
library(DSOpal)
connections <- datashield.login(logins=logindata, assign = T)

# Administrative functions
ds.listClientsideFunctions()
DSI::datashield.methods(conns=connections)
ds.listDisclosureSettings()
DSI::datashield.connections()


# Data Analysis functions (generally of type "Aggregate")
## Data structure queries
ds.class("D$AGE", datasources= connections)

ds.class("D$SEX", datasources= connections)
ds.levels("D$SEX", datasources= connections)

ds.class("D$SMOKE_ST", datasources= connections)
ds.levels("D$SEX", datasources= connections)

ds.class("D$SOD_POT", datasources= connections)

## Summary Statistics Functions
ds.summary("D$AGE", datasources= connections)
ds.summary("D$SEX", datasources= connections)
ds.summary("D$SMOKE_ST", datasources= connections)
ds.summary("D$SOD_POT", datasources= connections) # we can show how this can be automated with datashieldDescriptives

## Plotting graphs
ds.histogram(x="D$SOD_POT")
ds.histogram(x="D$AGE")


ds.cor(x='D$AGE', y='D$SOD_POT')
ds.scatterPlot(x='D$AGE', y='D$SOD_POT')



## Logging out
DSI::datashield.logout(connections)
