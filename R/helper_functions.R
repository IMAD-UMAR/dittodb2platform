#' Make connection to database
#' 
#' Wraper function to cut down clutter.
#' 
#' @return Formal class PqConnection
make_connection <- function(){
        DBI::dbConnect(RPostgres::Postgres(),
                              dbname = "platform",
                              host = "192.168.38.21",
                              port = 5432,
                              user = Sys.getenv("DB_USER"),
                              password = Sys.getenv("DB_PASSWORD"),
                              client_encoding = "utf8")
}


