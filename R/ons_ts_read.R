ts_read <- R6::R6Class(
  "ts_read",
  inherit = ons_reader,

  public = list(





     BASEURL="http://www.ons.gov.uk/generator?format=csv&uri="
    ,ROWS_TO_SKIP = 10 #rows to be skipped in the csv file

    ,initialize = function(code){

      super$initialize(code)
      self$set_title()

    }


    ,set_title = function(){
      if(self$proceed == self$DO_NOTHING){return('title could not be set')} #code not supplied
      my_sql <-  sprintf("select caption from ons_timeseries where upper(code)='%s' limit 1",toupper(self$code))
      my_data <- private$run_sql(my_sql)

      if(nrow(my_data)>0) {

        self$title <- my_data$caption[1]

      }else{

        cat( paste0(self$code," code does not exist in database \n"))
        self$proceed <- self$DO_NOTHING
        return(NULL)

      }

      invisible()

    }

    ,get_info = function(){
      my_sql <-  sprintf("select * from ons_timeseries where upper(code)='%s' limit 1",toupper(self$code))
      my_data <- private$run_sql(my_sql)
      return(my_data)
    }

    ,read_data = function(){

      if(self$proceed == self$DO_NOTHING){return(NULL)}

      temp <- self$get_info()
      if ( is.null(temp) ) {
        cat("Info returned nothing. Exiting function with NULL results.....\n")
        return(NULL)
      }

      url <- sprintf("%s%s",self$BASEURL,temp$uri)
      #cat(url,"\n")

      my_data <- try(
        read.csv(
          url,
          header=F,
          skip= self$ROWS_TO_SKIP,
          stringsAsFactors=F
        )
      )
      if (class(data) == "try-error") {  return("Error encountered during download!") }

      if(nrow(my_data) == 0){
        cat("No data found for ",self$code,'\n')
        return(NULL)
      }
      return(my_data)
    }


    ,search_info = function(qry=NULL,is_code = FALSE) {

      if(self$proceed == self$DO_NOTHING){return(NULL)}

      my_is_code <- is_code
      my_qry <- qry

      if (is.null(qry)) {
        my_qry <- self$code
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


