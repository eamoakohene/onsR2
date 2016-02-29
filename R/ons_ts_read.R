ts_read <- R6::R6Class(
  "ts_read",
  inherit = ons_utils,

  public = list(
     ons_code = NULL  #field for 4-letter ONS code
    ,ons_sql = NULL   #field for intermediate sql statement generated
    ,ons_url = NULL   #field for url to the csv file to be downloaded
    ,ons_df = NULL    #data.frame containing the meta data of the code to be downloaded

    #'base url
    ,BASEURL="http://www.ons.gov.uk/generator?format=csv&uri="
    ,ROWS_TO_SKIP = 10 #rows to be skipped in the csv file


    #'====initialize====
    #'Constructor for the onsR6 class. Accepts 4-letter \code{code} argument and setup parameters for
    #'dowloading the data.
    #'
    ,initialize = function(code){

      if(!missing(code)){
        self$set_code(code)
        self$build_sql()
      }else{
        stop("Please supply code")
      }

    }

    ,set_code = function(value){
      if (!missing(value) && !is.null(value)) {
        self$ons_code <- value
      }
      invisible(self)
    }

    ,get_code = function(){
      return(self$ons_code)
    }

    ,build_sql = function(){

      self$ons_sql <- sprintf("select * from ons_timeseries where code='%s' limit 1",self$ons_code)
      invisible(self)
    }

    #'===get_info====
    #'Returns the meta data of all records matching \code{code}.
    ,get_info = function(){
      my_sql <-  sprintf("select * from ons_timeseries where code='%s' limit 1",self$ons_code)
      my_data <- private$run_sql(my_sql)
      if(nrow(my_data)>0) {self$title <- my_data$caption[1]}
      return(my_data)
    }

    ,get_title = function(){
      return(self$title)
    }

    ,read_data = function(){

      temp <- self$get_info()
      if ( is.null(temp) ) {
        cat("Info returned nothing. Exiting function with NULL results.....\n")
        return(NULL)
      }

      url <- sprintf("%s%s",self$BASEURL,temp$uri)

      my_data <- try(
        read.csv(
          url,
          header=F,
          skip= self$ROWS_TO_SKIP,
          stringsAsFactors=F
        )
      )
      if (class(data) == "try-error") {  return("Error encountered during download!") }
      return(my_data)
    }


    ,search_info = function(qry=NULL,is_code = FALSE) {

      my_is_code <- is_code
      my_qry <- qry

      if (is.null(qry)) {
        my_qry <- self$ons_code
        my_is_code <- TRUE
      }

      my_sql <- NULL
      if (!my_is_code) {
        sql <- paste0(
          "select code, caption as description, url ",
          "from ons_timeseries where caption like '%",my_qry,"%';"
        )
      }else{
        my_sql <- paste0(
          "select code,caption as description, url ",
          "from ons_timeseries where code like '%",my_qry,"%';"
        )
      }

      return(private$run_sql(my_sql))
    }#search

  )



) #ons_ts_read


