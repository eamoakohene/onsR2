ts_read <- R6::R6Class(
  "ts_read",
  inherit = ons_reader,

  public = list(
     BASEURL="http://www.ons.gov.uk/generator?format=csv&uri="
    ,SBASEURL="https://www.ons.gov.uk/generator?format=csv&uri="
    ,ROWS_TO_SKIP = 10 #rows to be skipped in the csv file
    ,https = FALSE
    ,auto_grp = NULL
    ,auto_url = NULL


    ,initialize = function(code=NULL,code_req=TRUE, grp=NULL, https = FALSE){

      #fxn_show_boat(msg = match.call()[[1]])
      super$initialize(code,code_req, grp)

      if(code_req){
        self$set_title()
      }
      self$https <- https

    }


    ,set_title = function(){

      #fxn_show_boat(msg = match.call()[[1]])

      if(self$proceed == self$DO_NOTHING){return('title could not be set')} #code not supplied
      my_sql <-  sprintf("select title from ons_ds_headers where upper(code)='%s' limit 1",toupper(self$code))
      my_data <- private$run_sql(my_sql)

      if(nrow(my_data)>0) {

        self$title <- my_data$title[1]

      }else{
        cat(my_sql,"\n")
        cat( paste0(self$code," code does not exist in database \n"))
        self$proceed <- self$DO_NOTHING
        return(NULL)

      }

      invisible()

    }

    ,get_info = function(){

      my_sql <- sprintf("select * from ons_ds_headers where upper(code)='%s'",toupper(self$code))

      if( !is.null( self$code_grp ) ){

        my_sql <- sprintf("select * from ons_ds_headers where upper(code)='%s' and upper(grp) =='%s' ",toupper(self$code), toupper(self$code_grp) )

      }

      my_data <- private$run_sql(my_sql )

      if(nrow(my_data) == 1 ){

        return(my_data)

      }

      has_default <- dplyr::filter(my_data,code_default == 1)

      if(nrow(has_default) > 0){

        return( has_default[1,])

      }


      return(my_data[1,])
    }

    ,get_url = function(is_new = FALSE){

      is_new <- !is.null( self$code_grp )

      temp <- self$get_info()
      if ( is.null(temp) ) {
        cat("Info returned nothing. Exiting function with NULL results.....\n")
        return(NULL)
      }

      self$auto_grp <- temp$grp[1]

      is_secured <- ( as.integer(temp$secure) == 1)
      #cat('is_secured passed ', is_secured,'\n')

      if( !(is_secured || self$https == T)){

        self$auto_url <- tolower(sprintf("%s%s/%s",self$BASEURL,temp$uri, self$auto_grp))

          if(!is_new){
            return( tolower(sprintf("%s%s",self$SBASEURL,temp$uri)) )
          }else{
            return( tolower(sprintf("%s%s/%s",self$SBASEURL,temp$uri, temp$grp)) )
          }

      }else{

        #cat('has entered secure session ', is_secured,'\n')
        the_url <- NULL

        self$auto_url <- tolower(sprintf("%s%s/%s",self$SBASEURL,temp$uri, self$auto_grp))

        if(!is_new){
          the_url <- tolower(sprintf("%s%s",self$SBASEURL,temp$uri))
        }else{
         the_url <-  tolower(sprintf("%s%s/%s",self$SBASEURL,temp$uri, temp$grp))
        }

        #cat('URL =  ', the_url,'\n')

        return( the_url)
      }

    }

    ,read_url = function(my_url) {
      out <- tryCatch(
        {
          read.csv( my_url, header=F,  skip= self$ROWS_TO_SKIP, stringsAsFactors=F)
        },
        error = function(cond) {
          message(paste("URL does not seem to exist:", my_url))
          return(NULL)
        },
        warning = function(cond) {
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

      if(self$proceed == self$DO_NOTHING){return(NULL)}

      url <- self$get_url( )
      my_data <- self$read_url_simple( url )

      if (is.null(my_data)) {

        url2 <- self$get_url()

        my_data2 <- self$read_url_simple( self$auto_url ) #url2


        if (is.null(my_data2)) {
                return("Error encountered during download!")
        }

        return(my_data2)
      }

      return(my_data)
    }

    ,search_info = function(qry=NULL,is_code = FALSE, all_fields = F) {


      my_is_code <- is_code
      my_qry <- qry

      if (is.null(qry)) {
        cat('Query string required \n')
        return(NULL)
      }


      my_sql <- NULL
      if (!my_is_code) {

        if(all_fields){
          my_sql <- paste0("select * from ons_ds_headers where title like '%",qtr,"%';")
        }else{
          my_sql <- paste0(
            "select code, title as description, url ",
            "from ons_ds_headers where title like '%",my_qry,"%';"
          )
        }
      }else{

        if(all_fields){

          my_sql <- paste0(
            "select * from ons_ds_headers where code like '%",my_qry,"%';"
          )

        }else{

          my_sql <- paste0(
            "select code, title as description, url ",
            "from ons_ds_headers where code like '%",my_qry,"%';"
          )
        }

      }

      return(private$run_sql(my_sql))
    }#search

  )

#/employmentandlabourmarket/peoplenotinwork/unemployment/timeseries/agpa/lms
#/employmentandlabourmarket/peoplenotinwork/unemployment/

) #ons_ts_read
