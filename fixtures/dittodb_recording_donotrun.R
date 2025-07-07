################################################################################
##      Code for recording the mock db fixtures and preparing
##  the list of available time series. This code only works on the IMAD
##  internal network. 
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
# get current list of timeseries
timeseries_old <- readRDS("data/available_timeseries.rds")

# get list of timeseries from files which may have been updated
sistat_series <- read.csv("data/indicators_sistat.csv", stringsAsFactors = FALSE)
bs_series <- read.csv("data/indicators_bs.csv", stringsAsFactors = FALSE) |> 
        mutate(Sector = as.character(Sector),
               Block = as.character(Block))
zrsz_series <- read.csv("data/indicators_zrsz.csv", stringsAsFactors = FALSE) |> 
        mutate(Block = as.character(Block))
eurostat_series <- read.csv("data/indicators_eurostat.csv", stringsAsFactors = FALSE)
oecd_series <- read.csv("data/indicators_oecd.csv")
umar_series <- read.csv("data/indicators_umar.csv")

timeseries <- bind_rows(
                       sistat_series,
                       bs_series,
                       zrsz_series,
                       eurostat_series,
                       oecd_series,
                       umar_series)

# get series ids and names from the database
ids <- sql_get_series_id_from_series_code(
        timeseries$Dataset.code, con, schema = "platform")
name_long_si <- sql_get_series_name_from_series(con, ids$id, schema = "platform")

timeseries$id <- ids$id
timeseries$name_long_si <- name_long_si$name_long
timeseries <- relocate(timeseries, c("id", "name_long_si"), .after = "Indicator")

# save updated timeseries list
saveRDS(timeseries, "data/available_timeseries.rds")

# get new timeseries
timeseries_new <- timeseries |> 
        anti_join(timeseries_old, by = "Dataset.code") 

## capture mocks for new timeseries only
################################################################################
start_db_capturing(path = "fixtures/")
con <- make_connection() 

outputs <- map(timeseries_new$id,  ~{
        sql_get_data_points_from_series_id(
                con, 
                .x)}) 

DBI::dbDisconnect(con)
dittodb::stop_db_capturing()


