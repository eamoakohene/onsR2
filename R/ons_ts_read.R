ts_read <- R6::R6Class(
  "ts_read",
  inherit = ons_reader,

  public = list(
     BASEURL="http://www.ons.gov.uk/generator?format=csv&uri="
    ,ROWS_TO_SKIP = 10 #rows to be skipped in the csv file

    ,initialize = function(code=NULL,code_req=TRUE){
      fxn_show_boat(msg = match.call()[[1]])
      super$initialize(code,code_req)

      if(code_req){
        self$set_title()
      }

    }


    ,set_title = function(){
      fxn_show_boat(msg = match.call()[[1]])
      if(self$proceed == self$DO_NOTHING){return('title could not be set')} #code not supplied
      my_sql <-  sprintf("select title from ons_ds_headers where upper(code)='%s' limit 1",toupper(self$code))
      my_data <- private$run_sql(my_sql)

      if(nrow(my_data)>0) {

        self$title <- my_data$title[1]

      }else{

        cat( paste0(self$code," code does not exist in database \n"))
        self$proceed <- self$DO_NOTHING
        return(NULL)

      }

      invisible()

    }

    ,get_info = function(){
      fxn_show_boat(msg = match.call()[[1]])
      my_data <- private$run_sql(sprintf("select * from ons_ds_headers where upper(code)='%s'",toupper(self$code)))

      if(nrow(my_data) == 1 ){
        return(my_data)
      }

      has_default <- dplyr::filter(my_data,code_default == 1)
      if(nrow(has_default) > 0){
        return( has_default[1,])
      }


      # my_sql <-  sprintf("select * from ons_ds_headers where upper(code)='%s' limit 1",toupper(self$code))
      # my_data <- private$run_sql(my_sql)

      return(my_data[1,])
    }

    ,get_url = function(is_new = FALSE){
      temp <- self$get_info()
      if ( is.null(temp) ) {
        cat("Info returned nothing. Exiting function with NULL results.....\n")
        return(NULL)
      }
      if(!is_new){
        return( tolower(sprintf("%s%s",self$BASEURL,temp$uri)) )
      }else{
        return( tolower(sprintf("%s%s/%s",self$BASEURL,temp$uri, temp$grp)) )
      }

    }
    ,read_url = function(my_url) {
      out <- tryCatch(
        {
          read.csv( my_url, header=F,  skip= self$ROWS_TO_SKIP, stringsAsFactors=F)
        },
        error = function(cond) {
          message(paste("URL does not seem to exist:", my_url))
          #message(cond)
          return(NULL)
        },
        warning = function(cond) {
          #message(paste("URL caused a warning:", my_url))
          #message(cond)
          return(NULL)
        },
        finally = {
          message(paste("Processed code:", self$code))
        }
      )
      return(out)
    }

    ,read_url_simple = function(my_url) {
      cat('Initiating ',self$code,"...\n")
      out <- try(
          read.csv( my_url, header=F,  skip= self$ROWS_TO_SKIP, stringsAsFactors=F)
        ,silent = T)
      if(class(out) == "try-error"){return(NULL)}
      return(out)
    }

    ,read_data = function(){
      fxn_show_boat(msg = match.call()[[1]])
      if(self$proceed == self$DO_NOTHING){return(NULL)}

#       temp <- self$get_info()
#       if ( is.null(temp) ) {
#         cat("Info returned nothing. Exiting function with NULL results.....\n")
#         return(NULL)
#       }

      url <- self$get_url(T)
      #cat(url,"\n")
      #err <- simpleError("Error encountered during download!")


      my_data <- self$read_url_simple(url)

      if (is.null(my_data)) {

        url2 <- self$get_url()

        my_data2 <- self$read_url_simple(url2)
        if (is.null(my_data2)) {
                return("Error encountered during download!")
        }

        # if(nrow(my_data2) == 0){
        #   cat("No data found for ",self$code,'\n')
        #   return(NULL)
        # }

        return(my_data2)
      }

      # if(nrow(my_data) == 0){
      #   cat("No data found for ",self$code,'\n')
      #   return(NULL)
      # }
      return(my_data)
    }


    ,search_info = function(qry=NULL,is_code = FALSE) {

      fxn_show_boat(msg = match.call()[[1]])

      my_is_code <- is_code
      my_qry <- qry

      if (is.null(qry)) {
        cat('Query string required \n')
        return(NULL)
      }

      fxn_show_boat('GONE PAST IS.NULL(QRY)')

      my_sql <- NULL
      if (!my_is_code) {
        my_sql <- paste0(
          "select code, title as description, url ",
          "from ons_ds_headers where title like '%",my_qry,"%';"
        )
      }else{
        my_sql <- paste0(
          "select code, title as description, url ",
          "from ons_ds_headers where code like '%",my_qry,"%';"
        )
      }
      fxn_show_boat(my_sql)

      return(private$run_sql(my_sql))
    }#search

  )



) #ons_ts_read


