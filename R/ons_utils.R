# devtools::use_package("R6")
# devtools::use_package("sqldf")
# devtools::use_package("rvest")

ons_utils <- R6::R6Class("ons_utils",

     public = list(

        db_path = "R:/packages/onsR2/" #currently just for internal stuff
       ,db_name = 'inst/extdata/onsR2.sqlite'
       ,db_dir =  ''  #"data/"
       ,db_full_path = NULL
       ,title = NULL # ons title for timeseries

       ,DAY_OF_MTH = 1   #dd of date yyyy-mm-dd when composing date for monthly or quarterly time series data
       ,MTH_OF_YR = 1    #mm of date yyyy-mm-dd when composing date for yearly time series data.

       #constants for extracting date column from downloaded data frame
       ,YEARLY = 4    # '2004'
       ,QUARTERLY = 7 # '2004 Q1'
       ,MONTHLY = 8   # '2004 JAN'

       ,initialize = function(db_path){
         self$set_db_path(db_path)
       }

       ,get_db_path = function(){
         if(is.null( self$db_full_path)){
           self$set_db_path()
         }
         return(self$db_full_path )
       }

       ,set_db_path = function(value){

         if (!missing(value) && !is.null(value)) {
           self$db_full_path <- value
         }else{
           self$db_full_path <- sprintf("%s%s%s",self$db_path, self$db_dir, self$db_name)
         }

         invisible(self)
       }


       ,download_data = function(){
         my_data <- self$read_data()

         nrows <- nrow( my_data )

         # first column rows with 4-character length are yearly data
         data_yr <- my_data[nchar(my_data$V1)==self$YEARLY,]

         # first column rows with 7-character length are yearly data
         data_qtr <- my_data[ nchar(my_data$V1) == self$QUARTERLY,]

         # first column rows with 8-character length are yearly data
         data_mth <- my_data[ nchar(my_data$V1) == self$MONTHLY,]


         return(
           list(
             data = my_data,
             data_yr = data_yr,
             data_qtr = data_qtr,
             data_mth = data_mth
           )
         )#return

       }

     #'===get_data ===
     #'return

     ,get_data = function(format='ts'){

       mydata <- self$download_data()
       if ( is.null( mydata)) {
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
     ,private = list(
       get_db_con = function(){
         return(
           DBI::dbConnect(RSQLite::SQLite(), dbname=self$get_db_path())
         )
       }

       ,run_sql = function(qry) {
         return(sqldf::sqldf(qry, dbname=self$get_db_path() ))
       }
     )

)
