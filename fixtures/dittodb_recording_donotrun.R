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
library(dplyr)
source("R/helper_functions.R")
con <- make_connection() 
## setup time series df
################################################################################

# get list of timeseries from files
sistat_series <- read.csv("data/indicators_sistat.csv", stringsAsFactors = FALSE)
bs_series <- read.csv("data/indicators_bs.csv", stringsAsFactors = FALSE) |> 
        mutate(Sector = as.character(Sector),
               Block = as.character(Block))
zrsz_series <- read.csv("data/indicators_zrsz.csv", stringsAsFactors = FALSE) |> 
        mutate(Block = as.character(Block))
eurostat_series <- read.csv("data/indicators_eurostat.csv", stringsAsFactors = FALSE)
timeseries <- bind_rows(
                       sistat_series,
                       bs_series,
                       zrsz_series,
                       eurostat_series)

ids <- sql_get_series_id_from_series_code(
        timeseries$Dataset.code, con, schema = "platform")
name_long_si <- sql_get_series_name_from_series(con, ids$id, schema = "platform")

timeseries$id <- ids$id
timeseries$name_long_si <- name_long_si$name_long
timeseries <- relocate(timeseries, c("id", "name_long_si"), .after = "Indicator")
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


