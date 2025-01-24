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
                              user = "postgres",
                              password = Sys.getenv("PG_PG_PSW"),
                              client_encoding = "utf8")
}

#' Execute Database Calls with Mocked Responses
#' 
#' A wrapper function that executes database calls using mocked responses from
#' pre-recorded fixtures. The function handles the setup of the mock database
#' environment and suppresses the default printing of results.
#'
#' @param expr An expression containing the database calls to be executed
#' @param path Character string specifying the path to the fixtures directory.
#'             Defaults to "fixtures/"
#'
#' @return The result of the evaluated expression, invisibly
mock_db_call <- function(expr, path = "fixtures/") {
        invisible(
                with_mock_path(path = path, {
                        with_mock_db({
                                expr
                        })
                })
        )
}

