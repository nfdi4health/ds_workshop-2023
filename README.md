# DataSHIELD Workshop 2023 
## Introduction
Due to varying degrees of informed consent from study participants and limitations originating from regulations and data privacy laws, sharing study datasets has been a great concern for many institutes that otherwise would like to collaborate in order to fully utilise the strength of their combined collected data. Hence, within the NFDI4Health framework, one aim is to enable institutes to participate in such research projects without actually ceding control over their data. 

DataSHIELD[1] is a software solution for secure data analysis of personal health data in the programming language R, in which data holders can keep their data behind a firewall on dedicated servers (Opal Servers) while researchers can remotely analyse data under tight control, send analyses requests and receive summary statistics back.

## How does DataSHIELD work?
Analysis requests are sent from a central analysis machine to several data-holding machine storing the harmonised data to be co-analysed. The data sets are analysed simultaneously but in parallel, linked by non-disclosive summary statistics. Analysis is taken to the data – not the data to the analysis.
![figure-1-datashield-deployment-architecture](https://github.com/nfdi4health/ds_workshop-2023/assets/104575409/96ea60e5-e641-416e-8a97-e9dae5b63769)

## You will need: 
- An up to date version of R and RStudio installed on your local machine
- The rights to install packages on your R session

## The DataSHIELD approach: aggregate and assign functions
**Assign functions** do not return an output to the client, with the exception of error or status messages. Assign functions create new objects and store them server-side either because the objects are potentially disclosive, or because they consist of the individual-level data which, in DataSHIELD, is never seen by the analyst. These new objects can include:
- new transformed variables (e.g. mean centred or log transformed variables)
- a new variable of a modified class (e.g. a variable of class numeric may be converted into a factor which R can then model as having discrete categorical levels)
- a subset object (e.g. a dataframe including gender as a variable may be split into males and females).

Assign functions return no output to the client except to indicate an error or useful messages about the object store on server-side.

**Aggregate functions** analyse the data server-side and return an output in the form of aggregate data (summary statistics that are not disclosive) to the client. The help page for each function tells us what is returned and when not to expect an output on client-side.
