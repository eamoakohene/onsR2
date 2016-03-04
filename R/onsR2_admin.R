###scrub new css
  # new_page <- 1
  # new_murl <- 'http://www.ons.gov.uk/timeseriestool?topic=/economy/nationalaccounts/balanceofpayments&page='
  # new_css <- '.flush--sm a'
  # new_durl <- 'http://www.ons.gov.uk'
  #
  # Run:
  # abc <- ons_meta$new(
  #   pg=new_page,
  #   base_murl = new_murl,
  #   pcss =  new_css,
  #   skips = 0,
  #   base_durl=new_durl,
  #   data_type="" # too specific
  # )
  # Run:   abc$get_links()
  # Run:  abc$get_add_sql(col_id = 1)

### testing readers
# Run: onsR2::ds_read$new("CHAY")$read_data() # abc <- ds_read$new('CHAY')
# Run: onsR2::ts_read$new("chay")$read_data() # abc <- ts_read$new('CHAY')
#
# Run:  onsR2::ds_read$new("CHAY")$get_info()
# Run:  onsR2::ts_read$new("chay")$get_info()
#
# Run:  onsR2::ds_read$new("CHAY")$search_info()
# Run:  onsR2::ts_read$new("chay")$search_info()
#
# Run:  onsR2::ds_read$new("CHAY")$get_data()
# Run:  onsR2::ts_read$new("chay")$get_data()

# Run:  onsR2::download("chay")
###update -dataset -  headers (database table : ons_ds_headers )
# Run:  onsR2::ons_ds_meta$new()$add_headers()

###Updating meta  - scrapping###
### scraps using http://www.ons.gov.uk/search?filter=time_series
### calls ons_meta$new(pg=i, data_type = 1)$add_links()
### Updates ons_timeseries db
# Run: update_ts_meta( pages=16)

### scraps using http://www.ons.gov.uk/search?filter=datasets
### calls ons_meta$new(pg=i, data_type = 3)$add_links()
### updates ons_datasets db
# Run: update_ds_meta( pages=11)

### scraps using
### updates the the url_csv column of ons_datasets db
# Run: update_ds_links()

### ts_scrap
### scraps timeseries data from http://www.ons.gov.uk/timeseriestool?topic
### this is addition to the one scrapped from http://www.ons.gov.uk/search?filter=time_series
#   ts_scrap()
# Run: for(i in 24:24) {onsR2::ts_scrap(grp_range=i:i, pg_range = 1:2000)}

### ts_scrap number of records as in vector in get_ts_source()
# aaa = c(
#   '1' = 4323,
#   '2' = 439,
#   '3' = 227,
#   '4' =667,
#   '5' =4695,
#   '6' =6451,
#   '7' =3063,
#   '8' =3649,
#   '9' =1181,
#   '10' =230,
#   '11' =8,
#   '12' =176,
#   '13' =117,
#   '14' =273,
#   '15' =1618,
#   '16' =376,
#   '17' =52,
#   '18' =493,
#   '19' =15,
#   '20' =219,
#   '21' =621,
#   '22' =1152,
#   '23' =3971,
#   '24' =310,
#   '25' =0
# )
