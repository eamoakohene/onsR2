ds_read <- R6::R6Class(
  "ds_read",
  inherit = ons_utils,

  public = list(

    code = NULL,
    HEADER_LIMIT = 8,

    initialize = function(code){
      self$set_code(code)
    }

    ,set_code = function(value){
      if (!missing(value) && !is.null(value)) {
        self$code <- toupper(trimws(value))
      }else{
        stop("Series code is required")
      }
      invisible(self)
    }

    ,get_code = function(){
      return(self$code)
    }

    ,get_info = function(){
       my_sql <- sprintf("select * from ons_ds_headers where upper(code)='%s'",self$code)
       my_data <- private$run_sql(my_sql)
       if(nrow(my_data)>0) {self$title <- my_data$title[1]}
       return(my_data)
    }

    ,get_title = function(){
      return(self$title)
    }

    ,read_data = function(){
      my_info <- self$get_info()
      if(nrow(my_info) == 0){
        cat("Info returned nothing. Exiting function with NULL results.....\n")
        return(NULL)
      }

      my_data <- try(data.table::fread(input=my_info$src, select= c(1,my_info$src_id), header=FALSE, skip = self$HEADER_LIMIT),silent = TRUE)
      if( class(my_data)=='try-error' ){cat("Error encountered. Exiting function with NULL results.....\n")}
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
