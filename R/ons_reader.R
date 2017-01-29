ons_reader <- R6::R6Class(
    "ons_reader",

    inherit = ons_utils,

    public = list(

       code = NULL,
       code_req = TRUE,
       title = NULL, # ons title for timeseries
       DO_NOTHING = 0,
       proceed = 1


      ,DAY_OF_MTH = 1   #dd of date yyyy-mm-dd when composing date for monthly or quarterly time series data
      ,MTH_OF_YR = 1    #mm of date yyyy-mm-dd when composing date for yearly time series data.

      #constants for extracting date column from downloaded data frame
      ,YEARLY = 4    # '2004'
      ,QUARTERLY = 7 # '2004 Q1'
      ,MONTHLY = 8   # '2004 JAN'

      #'====initialize====
      #'Constructor for the onsR6 class. Accepts 4-letter \code{code} argument and setup parameters for
      #'dowloading the data.
      #'
      ,initialize = function(code,code_req = TRUE){

        #fxn_show_boat(msg = match.call()[[1]])
        self$set_code(code_req)
        self$set_code(code)

        if(self$code_req ){

          if(is.null(self$code)){
              cat("Series code is required \n")
              self$proceed <- self$DO_NOTHING

              return(NULL)
          }
        }

      }

      ,set_code_req = function(value){

        #fxn_show_boat(msg = match.call()[[1]])
        if (!is.null(value)) {
          self$code_req <- value
        }
        invisible(self)

      }

      ,set_code = function(value){

        #fxn_show_boat(msg = match.call()[[1]])
        if (!missing(value) && !is.null(value)) {
          self$code <- toupper(trimws(value))

        }
        invisible(self)
      }

      ,get_code = function(){
        return(self$code)
      }

      ,get_title = function(){

        #fxn_show_boat(msg = match.call()[[1]])
        return(self$title)

      }

      ,download_data = function(){

        #fxn_show_boat(msg = match.call()[[1]])
        if(self$proceed == self$DO_NOTHING){return(NULL)}
        my_data <- self$read_data()

        if(is.null(my_data)){ return(NULL) }
        # if(!( regexpr("Error",my_data)[1] == 1 ) ){
        #   cat(self$code,":error encountered\n")
        #   return( NULL )
        # }

        names(my_data) <- c('date','value')

        my_data <- dplyr::filter(my_data,!is.na(value))

        # first column rows with 4-character length are yearly data
        data_yr <- my_data[nchar(my_data$date)==self$YEARLY,]

        # first column rows with 7-character length are yearly data
        data_qtr <- my_data[ nchar(my_data$date) == self$QUARTERLY,]

        # first column rows with 8-character length are yearly data
        data_mth <- my_data[ nchar(my_data$date) == self$MONTHLY,]


        return(
          list(
            data = my_data,
            data_yr = data_yr,
            data_qtr = data_qtr,
            data_mth = data_mth
          )
        )#return

      }

      ,get_data = function(format='ts'){

        #fxn_show_boat(msg = match.call()[[1]])
        if(self$proceed == self$DO_NOTHING){return(NULL)}

        mydata <- self$download_data()
        if ( is.null( mydata) ) {
          cat(self$code,':Error encountered during download!\n')
          return(NULL)
        }

        y_data <- NULL
        if (dim(mydata$data_yr)[1] != 0) {
          if (length(mydata$data_yr[,2]) > 0) {
            y_start <- as.integer(substring(mydata$data_yr[1,1],1,self$YEARLY))
            y_data <-
              ts(mydata$data_yr[,2],start = c(y_start,1),frequency = 1)
          }
        }

        q_data <- NULL
        if (dim(mydata$data_qtr)[1] != 0) {
          if (length(mydata$data_qtr[,2]) > 0) {

            q_start_yr <- as.integer(substring(mydata$data_qtr[1,1],1,self$YEARLY))
            q_start_qtr_desc <- substring(mydata$data_qtr[1,1],self$YEARLY + 2,self$QUARTERLY)

            q_start_qtr <- switch(
              q_start_qtr_desc,
              'Q1' = 1,
              'Q2' = 2,
              'Q3' = 3,
              'Q4' = 4
            )

            q_data <-
              ts(
                mydata$data_qtr[,2],start = c(q_start_yr,q_start_qtr),frequency = 4
              )

          }
        }

        m_data<-NULL
        if (dim(mydata$data_mth)[1] != 0) {
          if (length(mydata$data_mth[,2]) > 0) {
            m_start_yr <-
              as.integer(substring(mydata$data_mth[1,1] , 1 , self$YEARLY))
            m_start_mth_desc <-
              substring(mydata$data_mth[1,1] , self$YEARLY + 2 , self$MONTHLY)


            m_start_mth <- switch(
              m_start_mth_desc,
              'JAN' = 1,
              'FEB' = 2,
              'MAR' = 3,
              'APR' = 4,
              'MAY' = 5,
              'JUN' = 6,
              'JUL' = 7,
              'AUG' = 8,
              'SEP' = 9,
              'OCT' = 10,
              'NOV' = 11,
              'DEC' = 12
            )


            m_data <- ts(mydata$data_mth[,2],
                         start = c(m_start_yr,m_start_mth),
                         frequency = 12
            )
          }
        }

        title <- self$get_title()
        units <- ""

        if(format=='df'){

          if ( !is.null( m_data ) ) { m_data <- data.frame( date = self$ts_dates( m_data ), value = m_data )}
          if ( !is.null( q_data ) ) { q_data <- data.frame( date = self$ts_dates( q_data ), value = q_data )}
          if ( !is.null( y_data ) ) { y_data <- data.frame( date = self$ts_dates( y_data ), value = y_data )}
        }

        return(
          list(
            title = title,
            #units = units,
            m_data = m_data,
            q_data = q_data,
            y_data = y_data
          )#list
        )#return

      }

      ,ts_dates = function(myts){

        #fxn_show_boat(msg = match.call()[[1]])

        if ( frequency(myts) == 12 ) {
          return(seq(
            as.Date(paste(c(
              start(myts),self$DAY_OF_MTH
            ), collapse = "/")),
            by = "month",
            length.out = length(myts)
          ))
        }else if ( frequency(myts) == 4 ) {
          return(
            seq.Date(
              as.Date(
                paste(
                  start(myts)[1],start(myts)[2] * 3,self$DAY_OF_MTH,sep = "/"
                )
              ),
              length.out = length(myts),
              by = "3 months"
            )
          ) #return
        }else if (frequency(myts) == 1) {
          return(
            seq(
              as.Date(
                paste(
                  c( start(myts) ,self$DAY_OF_MTH ),
                  collapse = "/"
                )
              ),
              by = "year",
              length.out = length(myts)
            )
          )

        } else {

          stop("Frequency of time series UNKNOWN")
        }
      }

    )#public
)#R6
