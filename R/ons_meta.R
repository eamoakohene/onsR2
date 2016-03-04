
#' This class scraps the meta data from ONS website
#' There are 2 kinds of meta data; Timeseries and Dataset
#' SelectorGadget (from selectorgadget.com) was use to find the required selectors (base_css)
#' The ONS site is new and bound to undergo changes so should watch out for changes in base_murl and base_css
#'
#' The meta information are stored in 2 tables in sqlite database; ons_timeseries and ons_datasets.
#' ons_timeseries = has 3 colums (code, caption, url)
ons_meta <- R6::R6Class("ons_meta",
  inherit = ons_utils,
  public = list(

    base_murl =  c(
      'http://www.ons.gov.uk/search?filter=time_series&q=time%20series%20dataset&q=time%20series%20dataset&sortBy=release_date&page=',
      'http://www.ons.gov.uk/search?filter=datasets&q=time%20series%20dataset&q=time%20series%20dataset&sortBy=release_date&page='

    ),
    base_durl = "http://www.ons.gov.uk",

    base_css = c(
      '.search-results__item:nth-child(n+1) a' ,
      '.search-results__item:nth-child(n+1) a' ,
      '.col--lg-9:nth-child(1) .btn--thick'
    ),

    pcss = '.search-results__item:nth-child(n+1) a' ,
    pg = 1,
    skip_elements = 0,
    full_url = NULL,
    ts_data = NULL,

    TIMESERIES = 1,
    DATASET =2,
    CSV = 3,
    data_type = 1,

    #' Initialize the class with
    #' pg = page number
    #' base_murl = meta data url
    #' base_durl = time series data url
    #' pcss = page css
    #' skips = number of elements to skip in html nodes
    #' data_type = whether link is for ONS timeseries or dataset
    #'
    initialize = function(pg,base_murl,pcss,skips,base_durl,data_type=1){
      self$set_page(pg)
      self$set_type(data_type)
      self$set_murl(base_murl)
      self$set_css(pcss)
      self$set_skip_elements(skips)
      self$set_durl(base_durl)

    }

    ,set_page = function(value){
      if (!missing(value) && !is.null(value)) {
        self$pg <- value
        self$full_url <- self$build_url()
      }

      invisible(self)
    }

    ,build_url = function(){
      return(paste0(self$base_murl[ self$data_type ],self$pg))
    }

    #' Set the base url for meta data if supplied and set the full url with page number irrespective
    ,set_murl = function(value){

      if (!missing(value) && !is.null(value)) {
        self$full_url <- paste0(value, self$pg)
      }else{
        self$full_url <- self$build_url()
      }

      invisible(self)

    }

    ,set_type = function(value){

      if (!missing(value) && !is.null(value)) {
          self$data_type <- value
      }

      invisible(self)

    }


    ,set_durl = function(value){
      if (!missing(value) && !is.null(value)) {
        self$base_durl <- value
      }
      invisible(self)
    }

    ,set_css = function(value){
      if (!missing(value) && !is.null(value)) {
        self$pcss <- value
      }else{
        self$pcss <- self$base_css[ self$data_type]
      }

      invisible(self)
    }

    ,set_skip_elements = function(value){
      if (!missing(value) && !is.null(value)) {
        self$skip_elements <- value
      }
      invisible(self)
    }

    ,get_url = function(){
      return (self$full_url)
    }
    ,get_murl = function(){
      return (self$build_url())
    }

    ,get_codes = function(my_col,col_id = 0){

      if(self$data_type == self$TIMESERIES || col_id == 1){
        return(
          stringr::str_sub( my_col, -4, -1)
        )
      }

      if(self$data_type == self$DATASET || col_id == 2){
        return('')
      }


      if(self$data_type == self$CSV || col_id == 3){

       my_pos <- self$get_last_position('/',my_col)+1

       return(
         toupper(stringr::str_sub( my_col, my_pos , nchar(my_col)-4))
       )
      }

    }
    ,get_links = function(col_id = 0){

      my_page <- try(xml2::read_html(self$full_url), silent=TRUE)
      if(class(my_page)[1]=='try-error'){
        cat('Error occurred why reading page. Exiting now ...')
        return(NULL)
      }

      if(! is.null(my_page$node)){
        my_element <- rvest::html_nodes(my_page,self$pcss)
        my_caption <- gsub("[\r\n]","", rvest::html_text(my_element))
        my_links <- paste0( self$base_durl, rvest::html_attr(my_element,"href"))

        if(self$skip_elements > 0){
          my_caption <- my_caption[ -c(self$skip_elements) ]
          my_links <- my_links[ -c(self$skip_elements) ]
        }

        my_codes <- self$get_codes(my_links, col_id = col_id)
        self$ts_data <- data.frame( code = my_codes, caption = my_caption, link = my_links, stringsAsFactors = F)
      }
      return(self$ts_data)
    }

    ,get_add_sql = function(id, col_id=0){

      my_data <- self$get_links()
      my_sql <- NULL

      if(self$data_type == self$TIMESERIES || col_id==1 ){

        my_sql <- paste0("insert into ons_timeseries(code,caption,url) values ('",my_data$code,"','", gsub("'","",my_data$caption),"','",my_data$link,"');")
      }else if(self$data_type == self$DATASET || col_id==2){

        my_sql <- paste0("insert into ons_datasets(caption,url) values ('", gsub("'","",my_data$caption), "','",my_data$link,"');")

      }else{
        my_sql <-sprintf("update ons_datasets set code='%s',url_csv='%s' where id = %s ; ",my_data$code, my_data$link,id )
      }
      return(my_sql)

    }

    ,add_links = function(id, col_id = 0){

      my_sql <- self$get_add_sql(id=id, col_id = col_id)

      for(i in 1:length(my_sql)){
        RSQLite::dbSendQuery(private$get_db_con(), my_sql[i])
      }


    },

    get_last_position = function(chr,txt){
      my_reg <- sprintf("\\%s",chr)
      return( rev(gregexpr(my_reg, txt)[[1]])[1])
    }

    ,get_ts_meta = function(){
      return(
        sqldf::sqldf("select * from ons_timeseries order by caption",dbname=self$get_db_path())
      )

    }

    ,get_ds_meta = function(){
      return(
        sqldf::sqldf("select * from ons_datasets order by caption",dbname=self$get_db_path())
      )

      return(my_data)
    }



  ) #public

)#class

#' Update the meta information on ONS timeseries data
update_ts_meta <- function(pages=16){
  for(i in 1:pages){
    ons_meta$new(pg=i)$add_links()
  }
}

#' Update the meta information on ONS timeseries data
update_ds_meta <- function(pages=11){
  for(i in 1:pages){
    ons_meta$new(pg=i, data_type=3)$add_links()
  }
}
#'
#'
update_ds_links <- function(){

  my_data <- ons_meta$new()$get_ds_meta()

  for(i in 1:nrow(my_data)){
    abc <- ons_meta$new(
       pg='',
       base_murl = my_data$url[i] ,
       skips = 0,base_durl='http://www.ons.gov.uk'
       ,data_type=3
    )$add_links( id=my_data$id[ i ] )
  }
}

get_ts_source <- function(id=1){
  ts_group <- c(

      'Balance of payments' = '/economy/nationalaccounts/balanceofpayments',
      'Earnings and working hours' = '/employmentandlabourmarket/peopleinwork/earningsandworkinghours',
      'Economic inactivity' = '/employmentandlabourmarket/peoplenotinwork/economicinactivity',
      'Employment and employee types' = '/employmentandlabourmarket/peopleinwork/employmentandemployeetypes',
      'Gross domestic product (GDP)' = '/economy/grossdomesticproductgdp',
      'Gross value added (GVA)' = '/economy/grossvalueaddedgva',
      'Inflation and price indices' = '/economy/inflationandpriceindices',
      'International trade' = '/businessindustryandtrade/internationaltrade',
      'Investments, pensions and trusts' = '/economy/investmentspensionsandtrusts',
      'Labour productivity' = '/employmentandlabourmarket/peopleinwork/labourproductivity',
      'Leisure and tourism' = '/peoplepopulationandcommunity/leisureandtourism',
      'Manufacturing and production industry' = '/businessindustryandtrade/manufacturingandproductionindustry',
      'Mergers and acquisitions' = '/businessindustryandtrade/changestobusiness/mergersandacquisitions',
      'Out of work benefits' = '/employmentandlabourmarket/peoplenotinwork/outofworkbenefits',
      'Output' = '/economy/economicoutputandproductivity/output',
      'Public sector finance' = '/economy/governmentpublicsectorandtaxes/publicsectorfinance',
      'Public sector personnel' = '/employmentandlabourmarket/peopleinwork/publicsectorpersonnel',
      'Public spending' = '/economy/governmentpublicsectorandtaxes/publicspending',
      'Redundancies' = '/employmentandlabourmarket/peoplenotinwork/redundancies',
      'Research and development expenditure' = '/economy/governmentpublicsectorandtaxes/researchanddevelopmentexpenditure',
      'Retail Industry' = '/businessindustryandtrade/retailindustry',
      'Satellite accounts' = '/economy/nationalaccounts/satelliteaccounts',
      'UK sector accounts' = '/economy/nationalaccounts/uksectoraccounts',
      'Unemployment' = '/employmentandlabourmarket/peoplenotinwork/unemployment'
      #'Tourism industry' = '/businessindustryandtrade/tourismindustry'
  )


  if(id<= length( ts_group )){

    my_data <- sprintf("%s%s%s","http://www.ons.gov.uk/timeseriestool?topic=",ts_group[id],"&page=")
    names(my_data) <- names(ts_group[id])
    return( my_data )

  }else{
    cat('Index out of range. should be between 1 and ',length(ts_group) )
  }
}

ts_scrap = function(grp_range=1:23, pg_range=1:2000){


  for( i in grp_range){
    lnk <- get_ts_source(i)
    cat("Working on group ",names(lnk),"\n")
    for(j in pg_range){
      cat(" Working on group: ",names(lnk)," - page ",j,"\n")
      abc <- ons_meta$new(
        pg=j,
        base_murl = lnk[[1]],
        pcss =  '.flush--sm a',
        skips = 0,
        base_durl='http://www.ons.gov.uk',
        data_type=1
      )
      my_links <- abc$get_links()
      if(is.null( my_links)){ break}
      abc$add_links( col_id = 1)
    }
  }

}

ts_search_info <- function(code='mgsx', cs = '.btn--primary', uri_only = FALSE ){
  MAX_LEN <- 1000
  my_code <- code
  my_css <- cs

  my_url <- paste0('http://www.ons.gov.uk/search?q=',tolower(my_code))
  my_page <- try(xml2::read_html(my_url),silent = T)

  if(class(my_page)[1]=='try-error'){
    cat('Error occurred why reading page. Exiting now ...')
    return(NULL)
  }


  my_element <- rvest::html_nodes(my_page, my_css)
  if(is.null(my_element)){ return(NULL) }

  my_links <- rvest::html_attr(my_element, "href")
  if(is.null(my_links)){ return(NULL) }

  my_substr_start <- nchar('/generator?format=') + 1
  my_substr_end <- my_substr_start +nchar('csv') - 1
  my_link_csv <- my_links[ substr( my_links,my_substr_start, my_substr_end ) == 'csv' ]
  if(!uri_only){
    return( my_link_csv[1] )
  }else{

    my_remove <- nchar('/generator?format=csv&uri=')+1
    return(
      substr( my_link_csv[1], my_remove, MAX_LEN )
    )

  }
}

get_bmm_missing_codes <- function(indx=1,full=FALSE){
  my_codes <- c(
    'K22A',
    'MGSX',
    'MC9R',
    'MC9A',
    'K386',
    'K387',
    'K23K',
    'K23O',
    'JQF8',
    'JQ88',
    'JQ89',
    'JQ8J',
    'JQ9T',
    'JQF9',
    'JQJ7',
    'JQO3',
    'JQ9U',
    'JQO4',
    'K55I',
    'DSI3',
    'ABMI',
    'BAHY',
    'ENXO',
    'BQNJ',
    'L87S',
    'L87U',
    'L87Q',
    'ELBH',
    'BPAN',
    'BQBD',
    'BQAI',
    'CHNF',
    'ENYT',
    'CHOA',
    'CHNH',
    'CHOE',
    'CHNE',
    'CHNV',
    'CHOD',
    'EREL',
    'ERDS',
    'EREE',
    'EOBD',
    'EOBX',
    'EOCR',
    'EPNX',
    'EREK',
    'J9C6',
    'K38E',
    'JQZ3',
    'JQZ2',
    'JQY9',
    'JQX5',
    'JQX6',
    'L2MW',
    'YBEZ',
    'KLH7'

  )

  if(full){ return(my_codes)}

  if(indx %in% 1:length(my_codes)){
     return(my_codes[indx])
  }else{
    return(NULL)
  }

}

add_missing_codes <- function( indx=1){

  NO_MISSING_CODES <- length(get_bmm_missing_codes(indx,TRUE))

  for(i in 1:NO_MISSING_CODES){
    #i=1
    my_code <- get_bmm_missing_codes(i)
    my_caption <- onsR2::search(my_code,is_code = T,fx='ds')$description
    my_uri <- ts_search_info(my_code,uri_only=T)
    my_sql <- sprintf("insert into ons_timeseries (code,caption,uri) values ('%s','%s','%s'); ", my_code, my_caption, my_uri)

    RSQLite::dbSendQuery(
      DBI::dbConnect(
        RSQLite::SQLite(),
        dbname = 'R:/packages/onsR2/inst/extdata/onsR2.sqlite'
      ),
      my_sql
    )
    cat(toupper(my_code),' added successfully \n')
  }
}

