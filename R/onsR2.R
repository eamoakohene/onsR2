
#' Download ONS data using series 4-letter code (eg. cpi=D7BT)
#' format - output format, ts=timeseries, df=dataframe
#' fx - the source of data, ts = timeseries data, ds= dataset which is normally large
#'  spreadsheet containing several other series. It not as effecient as the ts source.

download <- function(code,format = 'ts',fx = 'ts', grp = NULL) {

  my_grp <- grp
  my_code <- code

  if(is.null( grp )){

     my_split <- strsplit( code, "-" )[[ 1 ]]

     if( length(my_split) >1 ){

       my_code <- my_split[1]
       my_grp <- my_split[2]

     }
  }

  if(fx == 'ts'){
    return(
        onsR2::ts_read$new( code = my_code, grp = my_grp)$get_data(format = format)
    )
  }else{
    return(
        onsR2::ds_read$new( code = my_code, grp = my_grp)$get_data(format = format)
    )

  }
}


search <- function(qry = NULL,is_code = FALSE, all_fields = F) {


     my_temp <- onsR2::ts_read$new( code_req = FALSE)

      return(
        my_temp$search_info(qry = qry,is_code=is_code, all_fields = all_fields)
      )


}

add <- function(fields = list() ){

  my_temp <- onsR2::ons_ds_meta$new()
  my_temp$add_code( clist = fields )

}
