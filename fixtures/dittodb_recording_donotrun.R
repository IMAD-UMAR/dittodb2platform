################################################################################
##      One off code for recording the mock db fixtures and preparing
##  the list of available time series. This code only works on the IMAD
##  internal network, and once run is kept here only for archival purposes. 
##           
##                              DO NOT RUN
##
################################################################################

## setup
################################################################################
library(dittodb)
library(UMARaccessR)
library(purrr)
source("R/helper_functions.R")
con <- make_connection() 
## setup time series df
################################################################################
series_codes <- c("SURS--0300230S--P52--GO4--N--Q",
                  "SURS--0300230S--P6--L--Y--Q",
                  "SURS--0300230S--B1GQ--L--Y--Q",
                  "SURS--0300230S--P51G--L--Y--Q",
                  "SURS--0300230S--P7--L--Y--Q",
                  "SURS--0300230S--P31_S1M--L--Y--Q",
                  "SURS--0300230S--P3_S13--L--Y--Q",
                  "SURS--0400600S--9999900104--50--M",
                  "SURS--0400600S--9999900105--50--M",
                  "SURS--0400600S--0--50--M",
                  "SURS--0457101S--B_TO_E--29--M",
                  "SURS--2080006S--2--J--M",
                  "SURS--1700102S--2--1--M",
                  "SURS--2012102S--2--7--M")

name_short_en <- c("Changes in inventories",
                   "Exports of goods and services",
                   "Real GDP",
                   "Gross fixed capital formation",
                   "Imports of goods and services", 
                   "Private consumption",
                   "Government consumption", 
                   "CPI: goods",
                   "CPI",
                   "CPI: services",
                   "PPI",
                   "Indices of services and trade production: J Information and communication",
                   "Industrial confidence: manufacturing",
                   "Business tendency in services: confidence indicator")


ids <- sql_get_series_id_from_series_code(
        series_codes, con, schema = "platform")

name_long_si <- sql_get_series_name_from_series(con, ids$id, schema = "platform")

timeseries <- data.frame(ids, series_codes, name_short_en, name_long_si)

saveRDS(timeseries, "data/available_timeseries.rds")


## capture mocks 
################################################################################
start_db_capturing(path = "fixtures/")
con <- make_connection() 

outputs <- map(timeseries$id,  ~{
        sql_get_data_points_from_series_id(
                con, 
                .x)}) 

DBI::dbDisconnect(con)
dittodb::stop_db_capturing()


