
#' Download ONS data using series 4-letter code (eg. cpi=D7BT)
#' format - output format, ts=timeseries, df=dataframe
#' fx - the source of data, ts = timeseries data, ds= dataset which is normally large
#'  spreadsheet containing several other series. It not as effecient as the ts source.

download <- function(code,format = 'ts',fx = 'ts') {
  if(fx == 'ts'){
    return(
        onsR2::ts_read$new(code = code)$get_data(format = format)
    )
  }else{
    return(
        onsR2::ds_read$new(code = code)$get_data(format = format)
    )

  }
}


search <- function(qry = NULL,is_code = FALSE,fx = 'ts') {
  #fxn_show_boat(msg = match.call()[[1]])
  if(fx == 'ts'){
     my_temp <- onsR2::ts_read$new( code_req = FALSE)
     #fxn_show_boat('SEARCH |> MY_TEMP OK')
      return(
        my_temp$search_info(qry = qry,is_code=is_code)
      )
  }else{
     return(
        onsR2::ds_read$new(code_req = FALSE)$search_info(qry = qry,is_code=is_code)
     )
  }

}

