


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

  if(fx == 'ts'){
      return(
        onsR2::ts_read$new(code = code)$search_info(qry = qry,is_code=is_code)
      )
  }else{
     return(
        onsR2::ds_read$new(code = code)$search_info(qry = qry,is_code=is_code)
     )
  }

}

