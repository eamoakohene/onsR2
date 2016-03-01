ds_read <- R6::R6Class(
  "ds_read",
  inherit = ons_reader,

  public = list(


    HEADER_LIMIT = 8,

    initialize = function(code){
      super$initialize(code)
      self$set_title()
    }

    ,get_info = function(){
       my_sql <- sprintf("select * from ons_ds_headers where upper(code)='%s'",toupper(self$code))
       my_data <- private$run_sql(my_sql)
       return(my_data)
    }
    ,set_title = function(){
      if(self$proceed == self$DO_NOTHING){return('')} # code not supplied
      my_sql <- sprintf("select title from ons_ds_headers where upper(code)='%s'",toupper(self$code))
      my_data <- private$run_sql(my_sql)
      if(nrow(my_data)>0) {
        self$title <- my_data$title[1]
      }else{

       cat(paste0(self$code," code does not exist in database \n"))
        self$proceed <- self$DO_NOTHING
      }
      invisible()

    }
    ,read_data = function(){
      cat('Reading data. Please wait ...')
      my_info <- self$get_info()
      if(nrow(my_info) == 0){
        cat("Info returned nothing. Exiting function with NULL results.....\n")
        return(NULL)
      }

      my_data <- try(
         read.csv(file=my_info$src, header=F, skip = (self$HEADER_LIMIT+2),stringsAsFactors = F )
        ,silent = TRUE
      )

      if( class(my_data)=='try-error' ){cat("Error encountered. Exiting function with NULL results.....\n")}

      if(nrow(my_data) >0) {
        my_data <- my_data[, c(1,my_info$src_id)]

      }else{
        cat("No data found for ",self$code,'\n')
        return(NULL)
      }
      return(my_data)
    }

    ,search_info = function(qry = NULL,is_code = FALSE) {
      my_is_code <- is_code
      my_qry <- qry

      if (is.null(qry)) {
        my_qry <- self$code
        my_is_code <- TRUE
      }

      my_sql <- NULL

      if (!my_is_code) {
        my_sql <- paste0("select code, title as description, src , src_id  from ons_ds_headers where title like '%",my_qry,"%';")

      }else{
        my_sql <- paste0("select code, title as description, src as uri, src_id from ons_ds_headers where code like '%",my_qry,"%';")
      }

      return( private$run_sql(my_sql) )

    }#search

  )
)
