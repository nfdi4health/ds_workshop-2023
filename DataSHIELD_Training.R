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


####### shall we have more than 1 table on our servers with same variables to simulate more connected Opal Servers???

#### Part 1: How to explore a new dataset and/or new DataSHIELD Options

# Administrative functions to find out which functions can be used, what the control settings are etc.
ds.listClientsideFunctions()
DSI::datashield.methods(conns=connections)
ds.listDisclosureSettings()
DSI::datashield.connections()
ds.listOpals()
ds.listServersideFunctions()


# How does the dataset look like?

ds.colnames()
ds.class()
ds.dim()
# ds.exists() maybe this one would be good after we create a new variable
ds.length()
ds.levels()
ds.ls()
ds.numNA()



#### Topic 2: How can I transform the individual level data on the server side?

ds.abs()
ds.completeCases()
ds.dataFrame() # ?
ds.exp()
ds.log()
ds.sqrt()
ds.recodeLevels()
ds.recodeValues()
ds.replaceNA()
ds.make()



#### Sub-Topic (or perhaps later?): Functions helping with faulty upload
#### could also be time point when we should how to use less than standard connections
#### i.e. connections[-1] etc...

ds.asInteger()
ds.asFactor()
ds.Boole()
ds.asNumeric()
ds.changeRefGroup()


#### Topic 3: Aggregate Functions



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
