# devtools::use_package("R6")
# devtools::use_package("sqldf")
# devtools::use_package("rvest")

ons_utils <- R6::R6Class("ons_utils",

   public = list(

      initialize = function(){}

   )#public

   ,private = list(

       get_db_con = function(){
         return(
           DBI::dbConnect(RSQLite::SQLite(), dbname=system.file("extdata/onsR2.sqlite",package="onsR2"))
         )
       }

       ,run_sql = function(qry) {
         return(sqldf::sqldf(qry, dbname=system.file("extdata/onsR2.sqlite",package="onsR2") ))
       }
   )

)
