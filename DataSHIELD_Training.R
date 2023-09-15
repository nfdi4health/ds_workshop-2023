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
               table = "N4HWorkshop23.WS_ActivE")
builder$append(server="EPIC-Potsdam", url="https://hsz.dife.de/zopal",
               user=readline("Input username: "),
               password=readline("Input password: "),
               table = "N4HWorkshop23.WS_EPIC")

logindata <- builder$build()


# Then perform login in each server
connections <- datashield.login(logins=logindata, assign = T, symbol = "D")


####### shall we have more than 1 table on our servers with same variables to simulate more connected Opal Servers???

#### Part 1: How to explore a new dataset and/or new DataSHIELD Options
# Administrative functions to find out which functions can be used, what the control settings are etc.

#### Get an overview of DataSHIELD client-side functions
ds.listClientsideFunctions()

#### Get an overview of allowed DataSHIELD server-side functions
DSI::datashield.methods(conns=connections)

#### Get an overview of discloure controls / settings
ds.listDisclosureSettings()

# How does the dataset look like?

ds.colnames("D")
ds.class("D$AGE")
ds.dim("D")
ds.length("D$AGE")
ds.levels("D$SEX")
ds.numNA("D$AGE")


#### Topic 2: How can I transform the individual level data on the server side?

ds.abs()
ds.completeCases()
ds.exp()
ds.log()
ds.sqrt()
#ds.recodeLevels()
#ds.recodeValues()
#ds.replaceNA()
#ds.make()

ds.dataFrame()
ds.exists()

#### Sub-Topic (or perhaps later?): Functions helping with faulty upload
#### Example with numeric variable that should be categorical
#### Example text variable for asNumeric
#### i.e. connections[-1] etc...

ds.asInteger()
ds.asFactor()
ds.asNumeric()


#### Topic 3: Aggregate Functions + Models (at least GLM)

ds.cor()
ds.cov()
ds.kurtosis()
ds.mean()
ds.meanSdGp()
# ....


#### Topic 4: Plots

#### histogram, scatterplot (noise options, and why this is still complying with privacy control)


#### Topic 5: other cases, e.g. different DS packages
#### Having additional package installed on MDC Opal which DIfE does not have
# install packages other than dsBase
# library client side etc bla bla...
#### datashieldDescriptives Example
#### maybe example from cluster




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
