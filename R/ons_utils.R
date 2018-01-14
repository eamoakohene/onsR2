# devtools::use_package("R6")
# devtools::use_package("sqldf")
# devtools::use_package("rvest")

ons_utils <- R6::R6Class("ons_utils",

   public = list(

      initialize = function(local = FALSE){

        self$set_local( local )

      }

      ,set_local = function( value){

         if(!is.null(value) && is.logical( value )){
           private$is_local <- value
         }
      }

      ,run_qry = function(qry){
        private$run_sql(qry)
      }


   )#public

   ,private = list(
       is_local = FALSE,

       get_db_con = function(){

         if(private$is_local){
           return(
             DBI::dbConnect(RSQLite::SQLite(), dbname='R:/packages/onsR2/inst/extdata/onsR2.sqlite')
           )
         }else{
           return(
             DBI::dbConnect(RSQLite::SQLite(), dbname=system.file("extdata/onsR2.sqlite",package="onsR2"))
           )
         }
       }

       ,run_sql = function(qry) {

         if(private$is_local){
           return(sqldf::sqldf(qry, dbname='R:/packages/onsR2/inst/extdata/onsR2.sqlite' ))
         }else{
           return(sqldf::sqldf(qry, dbname=system.file("extdata/onsR2.sqlite",package="onsR2") ))
         }

       }
   )

)

fxn_show_boat <- function(msg = match.call()[[1]]){

  #my_msg <- sprintf("Hi I am in %s wheeeeeez!",toupper(msg))
  #cat(my_msg,'\n')
}

