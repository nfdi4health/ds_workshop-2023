

#### Installation of developer tools library, so that packages can be installed directly from GitHub
install.packages(devtools)
library(devtools)

#### Install DataSHIELD packages and dependencies if not already done
install.packages('DSI')
install.packages('DSOpal', dependencies=TRUE)
install_github("datashield/dsBaseClient", ref = "6.2.0")


#### Load DataSHIELD libraries
library(DSI)
library(DSOpal)
library(dsBaseClient)

#### Filling in information from DHO to connect to the Opal Servers
#### The server name (eg ActivE, EPIC) can be chosen independently by users
builder <- DSI::newDSLoginBuilder()
builder$append(server="ActivE", url="https://dsmolep.mdc-berlin.de",
               user="gmds2023",
               password="Gmds!2023",
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

#### Get an overview of DataSHIELD client-side functions
ds.listClientsideFunctions()

#### Get an overview of allowed DataSHIELD server-side functions
DSI::datashield.methods(conns=connections)

#### Get an overview of discloure controls / settings
ds.listDisclosureSettings()






#### Part 1B: Functions that provide feedback on the datasets or variables - How does the dataset look like?
?ds.colnames
ds.colnames("D")

#### How to select to which of the connected Opal Servers an analysis request is sent
ds.colnames(x = "D",
            datasources = connections)

ds.colnames(x = "D",
            datasources = connections[2])

ds.colnames(x = "D",
            datasources = connections[c(1,2)])

ds.colnames(x = "D",
            datasources = connections[-2])

ds.class(x = "D$SEX")
ds.class(x = "D$AGE")
ds.class(x = "D$SMOKE_ST")
ds.class(x = "D$SOD_POT")



#### Fixing upload errors (mostly stemming from data dictionary, should be minimised
#### when using the harmonizr package)

?ds.asNumeric

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




#### Some functions allow different display upon execution
?ds.dim
ds.dim(x = "Data_Corr",
       type = "split")

ds.dim(x = "Data_Corr",
       type = "combined")

ds.dim(x = "Data_Corr",
       type = "both")

ds.length(x = "Data_Corr$AGE_Corr")
ds.levels(x = "Data_Corr$SEX")
ds.numNA(x = "Data_Corr$SOD_POT")






#### Topic 2A: How can I transform the individual level data on the server side?
?ds.abs

ds.abs(x = "Data_Corr$SOD_POT")

ds.abs(x = "Data_Corr$SOD_POT",
       newobj = "SOD_POT_ABS")


ds.log(x = "Data_Corr$SOD_POT",
       newobj = "SOD_POT_LOG")


ds.completeCases(x = "Data_Corr",
                 newobj = "Data_Corr_Clean")


#### Not entirely sure on this section yet, I might use it in the glm model building part further down
ds.dataFrame(x = c("Data_Corr$AGE_Corr",
                   "Data_Corr$SEX",
                   "SOD_POT_LOG"),
             newobj = "Data4Analysis")

ds.exists("Data4Analysis")

ds.colnames("Data4Analysis")



#### Topic 3A: Aggregate Functions - receiving summary statistics
?ds.meanSdGp

ds.mean(x = "Data_Corr$AGE_Corr")
ds.cov(x = "Data_Corr$AGE_Corr")

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

mod <- ds.glm(formula = "SMOKE_ST_Corr~AGE_Corr+SEX",
              data = "Data_Corr",
              family = "binomial",
              datasources = connections)
mod

#### Topic 4: Plotting Graphs: How is this possible in DataSHIELD (we should add Demetris
#### paper to the PPTX or Readme File)
?ds.histogram

ds.histogram(x="Data_Corr$SOD_POT")
ds.histogram(x="Data_Corr$AGE_Corr")



?ds.scatterPlot

ds.scatterPlot(x='Data_Corr$AGE_Corr',
               y='Data_Corr$SOD_POT')



#### Topic 5: Improved analyst experience by using datashieldDescriptives (work in progress)
#### This is a client-side only package that only modifies output from dsBaseClient functions

install.packages("remotes")
library(remotes)
# no need to update
remotes::install_github("sofiasiamp/datashieldDescriptives")

library(datashieldDescriptives)

datashieldDescriptives::datashield_descriptive(df="Data_Corr",
                                               dsfunction = ds.class,
                                               opal_connection = connections,
                                               save = F
                                               )

datashieldDescriptives::datashield_descriptive(df="Data_Corr",
                                               dsfunction = ds.numNA,
                                               opal_connection = connections,
                                               save = F
)

datashieldDescriptives::datashield_descriptive(df="Data_Corr",
                                               dsfunction = ds.length,
                                               opal_connection =  connections,
                                               save = F
)

datashieldDescriptives::datashield_summary(df = "Data_Corr",
                                           opal_connection = connections,
                                           save = F
                                           )


datashieldDescriptives::datashield_table(df = "Data_Corr",
                                         opal_connection = connections
)


#### Topic 6: other cases, e.g. different DS packages
#### Having additional package installed on MDC Opal which DIfE does not have
#### install packages other than dsBase
#### library client side etc bla bla...
#### maybe example from cluster



#### Saving workspace?
datashield.workspace_save(connections, "my-workspace-datashield")

datashield.workspaces(connections)

#### Logging out
DSI::datashield.logout(connections)
