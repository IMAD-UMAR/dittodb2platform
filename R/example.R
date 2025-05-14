################################################################################
##      Example of accessing timeseries data from the IMAD database           ##
##               using mock fixtures when DB is not accessible                ##
################################################################################

## SETUP
################################################################################
library(dittodb)
source("R/helper_functions.R")
library(UMARaccessR)
library(purrr)
library(dplyr)
# get pre-prepared list of available series
timeseries <- readRDS("data/available_timeseries.rds")

## CONNECT TO MOCK DATABASE 
## (the fixtures are saved in the folder fixtures/
################################################################################

## Example of single series retrieval
db_call({
        #' all the code run within this function will return query 
        #' outputs as if you were actually connected to the database
        #'  - of course under the condition that such a query was first 
        #' recorded and its output is saved in the fixtures/ folder
        con <- make_connection()
        #' example returning a single time series with the (internal)
        #' id = 171, the default date_valid is NULL meaning the most recent
        #' vintage was returned
        var1 <- sql_get_data_points_from_series_id(con, 56395, "var1")
})


## Example of unsuccessful single series retrieval - won't work remotely
db_call({
        con <- make_connection()
        #' example returning a single time series with the (internal)
        #' id = 172, which was not recorded
        var2 <- sql_get_data_points_from_series_id(con, 172, "var2")
})

## Example of multiple series retrieval
db_call({
        con <- make_connection()
        #' return set of quarterly time series
        series_q <- timeseries |> 
                dplyr::filter(grepl("[Q]$", Dataset.code)) |> 
                select(id, Indicator) |> 
                with(map2(id, Indicator, ~{
                        sql_get_data_points_from_series_id(
                                con, 
                                .x,
                                new_name = .y)
                })) |>
                reduce(left_join, by = "period_id")
        
        #' return set of monthly time series
        series_m <- timeseries |> 
                dplyr::filter(grepl("[M]$", Dataset.code)) |> 
                select(id, Indicator) |> 
                with(map2(id, Indicator, ~{
                        sql_get_data_points_from_series_id(
                                con, 
                                .x,
                                new_name = .y)
                })) |>
                reduce(left_join, by = "period_id")
        #' return set of annual time series
        series_a <- timeseries |> 
                dplyr::filter(grepl("[A]$", Dataset.code)) |> 
                select(id, Indicator) |> 
                with(map2(id, Indicator, ~{
                        sql_get_data_points_from_series_id(
                                con, 
                                .x,
                                new_name = .y)
                })) |>
                reduce(left_join, by = "period_id")
})

