

#### Installation of developer tools library, so that packages can be installed directly from GitHub
install.packages("devtools")


#### Install DataSHIELD packages and dependencies if not already done
install.packages('DSI')
install.packages('DSOpal', dependencies=TRUE)
devtools::install_github("datashield/dsBaseClient", ref = "6.2.0")
devtools::install_github("sofiasiamp/datashieldDescriptives")

#### https://dsmolep.mdc-berlin.de/ui/index.html
#### https://hsz.dife.de/zopal/ui/index.html#!dashboard

#### Load DataSHIELD libraries
library(DSI)
library(DSOpal)
library(dsBaseClient)

#### Filling in information from DHO to connect to the Opal Servers
#### The server name (eg ActivE, EPIC) can be chosen independently by users
builder <- DSI::newDSLoginBuilder()
builder$append(server="ActivE", url="https://dsmolep.mdc-berlin.de",
               user="dgepi2023",
               password="DGEpi2023!",
               table = "N4HWorkshop23.WS_ActivE")
builder$append(server="EPIC", url="https://hsz.dife.de/zopal",
               user="N4HWS2301",
               password="DifeWS$2023",
               table = "N4HWorkshop23.WS_EPIC")
builder$append(server="EPIC_Mod", url="https://hsz.dife.de/zopal",
               user="N4HWS2301",
               password="DifeWS$2023",
               table = "N4HWorkshop23.WS_EPIC_Mod")

logindata <- builder$build()


#### Performing actual login to each server
connections <- datashield.login(logins=logindata, assign = T, symbol = "D")


#### How do I get help on functions
?datashield.login





#### Part 1: How to explore a new dataset and/or new DataSHIELD Options
#### Part 1A: Administrative functions to find out which functions can be used, what the control settings are etc.

#### Get an overview of DataSHIELD client-side functions, allowed DataSHIELD server-side functions & discloure controls / settings
ds.listClientsideFunctions()
server_function <- DSI::datashield.methods(conns=connections)
disclosure_settings <- ds.listDisclosureSettings()



#### Part 1B: Functions that provide feedback on the datasets or variables - How does the dataset look like?
ds.colnames("D")

#### How to select to which of the connected Opal Servers an analysis request is sent
ds.colnames(x = "D",
            datasources = connections[c(1,2)])

ds.class(x = "D$SEX")
ds.class(x = "D$AGE")
ds.class(x = "D$SMOKE_ST")
ds.class(x = "D$SOD_POT")

#### Fixing upload errors within DataSHIELD


ds.asNumeric(x.name = "D$AGE",
             newobj = "AGE_Corr",
             datasources = connections)


ds.asFactor(input.var.name = "D$SMOKE_ST",
            newobj.name = "SMOKE_ST_Corr",
            datasources = connections)

ds.dataFrame(x = c("D$SEX",
                   "AGE_Corr",
                   "SMOKE_ST_Corr",
                   "D$SOD_POT"),
             newobj = "Data_Corr")

ds.ls()


#### Some functions allow different display upon execution

ds.dim(x = "Data_Corr",
       type = "split")

ds.length(x = "Data_Corr$AGE_Corr")

ds.levels(x = "Data_Corr$SEX")

ds.numNA(x = "Data_Corr$SOD_POT")



#### Topic 2A: How can I transform the individual level data on the server side?
ds.abs(x = "Data_Corr$SOD_POT",
       newobj = "SOD_POT_ABS")

ds.log(x = "Data_Corr$SOD_POT",
       newobj = "SOD_POT_LOG")

ds.completeCases(x = "Data_Corr",
                 newobj = "Data_Corr_Clean")





#### Topic 3A: Aggregate Functions - receiving summary statistics

ds.mean(x = "Data_Corr$AGE_Corr",
        type = "combine")

ds.meanSdGp(x = "Data_Corr$AGE_Corr",
            y = "Data_Corr$SMOKE_ST_Corr")

ds.cor(x='Data_Corr$AGE_Corr',
       y='Data_Corr$SOD_POT')


ds.summary(x = "Data_Corr$AGE_Corr",
           datasources= connections)

ds.summary(x = "Data_Corr$SEX",
           datasources= connections)

ds.summary(x = "Data_Corr$SMOKE_ST_Corr",
           datasources= connections)

ds.summary(x = "Data_Corr$SOD_POT",
           datasources= connections)



#### Topic 3B: Building Models

mod <- ds.glm(formula = "SOD_POT~AGE_Corr+SEX",
              data = "Data_Corr",
              family = "gaussian",
              datasources = connections)
mod



mod2 <- ds.glm(formula = "SMOKE_ST_Corr~AGE_Corr+SEX",
              data = "Data_Corr",
              family = "binomial",
              datasources = connections)
mod2

#### Topic 4: Plotting Graphs: How is this possible in DataSHIELD?
#### https://bmcmedinformdecismak.biomedcentral.com/articles/10.1186/s12911-022-01754-4


ds.histogram(x="Data_Corr$SOD_POT")

ds.scatterPlot(x='Data_Corr$AGE_Corr',
               y='Data_Corr$SOD_POT')



#### Topic 5: Improved analyst experience by using datashieldDescriptives (work in progress)
#### This is a client-side only package that only modifies output from dsBaseClient functions


library(datashieldDescriptives)

ds.class(x = "D")


study_class_overview <- datashieldDescriptives::datashield_descriptive(df = "D",
                                                                       dsfunction = ds.class,
                                                                       opal_connection = connections,
                                                                       save = FALSE)


datashieldDescriptives::datashield_descriptive(df = "Data_Corr",
                                               dsfunction = ds.length,
                                               opal_connection =  connections,
                                               save = FALSE)

ds_ws <- datashieldDescriptives::datashield_summary(df = "Data_Corr",
                                           opal_connection = connections,
                                           save = FALSE)


datashieldDescriptives::datashield_table(df = "Data_Corr",
                                         opal_connection = connections)




#### Logging out
DSI::datashield.logout(connections)







#### Evaluation using QR Code






