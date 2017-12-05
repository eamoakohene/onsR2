
ons_ds_meta <- R6::R6Class(
  "ons_ds_meta",

  inherit = ons_utils,

  public = list(

    HEADER_LIMIT = 8,

    initialize = function(){}

    ,get_headers = function(fn = NULL){

      my_file <- fn

      my_data <- read.csv( my_file, header = F, stringsAsFactors = F)

      my_cols <- dim(my_data)[2]
      my_rows <- dim(my_data)[1]

      if(my_rows > self$HEADER_LIMIT){
        my_data <- my_data[c(1:self$HEADER_LIMIT),]
      }

      return(my_data)
    }

    ,get_csv = function(){
       my_sql <- "select * from ons_datasets where url_csv is not null"
       my_data <- private$run_sql(my_sql)
       my_data$csv <- tolower(stringr::str_sub( my_data$url_csv, -3, -1))

       my_data <- dplyr::filter(my_data, csv=='csv')
       return(my_data)
    }

    ,add_headers = function(tbl_range=1:1000, col_range = 2:100000){

       my_sql_base <- "insert into ons_ds_headers (title, code, sadj, pre_unit, unit, rel_date, next_rel_date, notes, src, src_id) values ('%s','%s','%s','%s','%s','%s','%s','%s','%s',%s);"

       my_csv <- self$get_csv()

       for (j in tbl_range){

             if(j > nrow(my_csv) ){break}

             my_data <- self$get_headers( my_csv$url_csv[j] )
             my_cols <- dim(my_data)[2]

             #my_sql <- character( my_cols - 1 )

             for(i in col_range){

               if(i > my_cols){break}

               cat("Adding ",my_csv$caption[j]," column ",i," of ",my_cols,"\n")
               my_sql <- sprintf(my_sql_base,
                                 gsub("'","",my_data[1,i]),
                                 gsub("'","",my_data[2,i]),
                                 gsub("'","",my_data[3,i]),
                                 gsub("'","",my_data[4,i]),
                                 gsub("'","",my_data[5,i]),
                                 gsub("'","",my_data[6,i]),
                                 gsub("'","",my_data[7,i]),
                                 gsub("'","",my_data[8,i]),
                                 gsub("'","",my_csv$url_csv[j]),
                                    i
                                )
               DBI::dbSendQuery(private$get_db_con(), my_sql)
             }
       }
    }
    ,add_code = function( clist = list() ){

      all_codes <- c(
        'title',	'code',	'sadj',	'unit',	'notes',	'src',	'grp',	'url',	'uri_base',	'code_lwr',	'uri',	'code_grp'
      )
      req_codes <- c(
        'code','title','unit','grp','url',	'uri_base','uri'
      )

      n_list <- length( clist )

      req_ok <- sum( req_codes %in% names(clist) ) == length( req_codes )
      fields_ok <- sum( names(clist) %in% all_codes) == n_list

      if(n_list > 0 && req_ok && fields_ok ){

        my_sql <- sprintf(" insert into ons_ds_headers( %s ) values %s ",
                     paste(names( clist ),sep = "", collapse = ","),
                     beamaUtils::split_str( paste( clist ,sep = "", collapse = ",") )
              )

        DBI::dbSendQuery(private$get_db_con(), my_sql)
        return(my_sql)

      }

      if(n_list == 0){
        cat("Empty list\n")

      }

      if(!req_ok){
        cat("List fields do meet REQUIRED fields criteria (code,title,unit,grp,url,uri_base,uri)\n")
      }

      if(!fields_ok){
        cat("List contains unknown fields \n")
      }


    }


  )#public

)#R6

