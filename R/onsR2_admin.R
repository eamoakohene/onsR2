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


# onsR2::download('JQ99')
# onsR2::download('JQR4')
# onsR2::download('JQS8')
# onsR2::download('JQ97')
# onsR2::download('JQR2')
# onsR2::download('JQS6')
# onsR2::download('JQU2')
# onsR2::download('BQKU')
# onsR2::download('BQKV')
# onsR2::download('K55K')
# onsR2::download('K22A')
# onsR2::download('D7BT')
# onsR2::download('CHAW')
# onsR2::download('JVZ7')
# onsR2::download('K646')
# onsR2::download('DYDC')
# onsR2::download('KAB9')
# onsR2::download('MGSC')
# onsR2::download('MGSX')
# onsR2::download('MC9R')
# onsR2::download('MC9Q')
# onsR2::download('MC9S')
# onsR2::download('MC9V')
# onsR2::download('MC99')
# onsR2::download('MC9A')
# onsR2::download('MC9B')
# onsR2::download('MC9C')
# onsR2::download('MC3I')
# onsR2::download('K384')
# onsR2::download('K385')
# onsR2::download('K386')
# onsR2::download('K387')
# onsR2::download('K388')
# onsR2::download('K389')
# onsR2::download('K23D')
# onsR2::download('K23H')
# onsR2::download('K23K')
# onsR2::download('K23O')
# onsR2::download('K23Q')
# onsR2::download('K23S')
# onsR2::download('K23U')
# onsR2::download('K23V')
# onsR2::download('JQ9S')
# onsR2::download('JQ9Y')
# onsR2::download('JQF8')
# onsR2::download('JQJ6')
# onsR2::download('JQO2')
# onsR2::download('JQ88')
# onsR2::download('JQ82')
# onsR2::download('JQ8H')
# onsR2::download('JQ89')
# onsR2::download('JQ83')
# onsR2::download('JQ8I')
# onsR2::download('JQ8A')
# onsR2::download('JQ84')
# onsR2::download('JQ8J')
# onsR2::download('JQ9T')
# onsR2::download('JQ9Z')
#
# onsR2::download('JQF9')
# onsR2::download('JQJ7')
# onsR2::download('JQO3')
# onsR2::download('JQ9U')
# onsR2::download('JQA2')
# onsR2::download('JQG2')
# onsR2::download('JQJ8')
# onsR2::download('JQO4')
# onsR2::download('JT27')
# onsR2::download('JT28')
# onsR2::download('K57P')
# onsR2::download('K57Q')
# onsR2::download('K57R')
# onsR2::download('K57S')
# onsR2::download('K57T')
# onsR2::download('K57U')
# onsR2::download('K55I')
# onsR2::download('K55J')
# onsR2::download('K583')
# onsR2::download('K584')
# onsR2::download('K585')
# onsR2::download('DSE9')
# onsR2::download('DS4H')
# onsR2::download('DSI3')
# onsR2::download('DS3N')
# onsR2::download('ABMI')
# onsR2::download('S2KU')
# onsR2::download('K222')
#
# onsR2::download('BAFC')
# onsR2::download('BQBM')
# onsR2::download('BAHA')
# onsR2::download('BQBN')
# onsR2::download('BAHY')
# onsR2::download('ELAB')
# onsR2::download('BOGT')
# onsR2::download('ELAJ')

# onsR2::download('IKBH')
# onsR2::download('IKBI')
# onsR2::download('IKBJ')
# onsR2::download('BOKG')
# onsR2::download('BOKH')
# onsR2::download('BOKI')
# onsR2::download('ELBL')
# onsR2::download('ENXO')
# onsR2::download('ENXQ')
# onsR2::download('BQNI')
# onsR2::download('BOQM')
# onsR2::download('BPBN')
# onsR2::download('BQNJ')
# onsR2::download('BQBH')
# onsR2::download('BQAX')
# onsR2::download('IKBB')
# onsR2::download('IKBC')
# onsR2::download('IKBD')
# onsR2::download('L87S')
# onsR2::download('L87U')
# onsR2::download('L87Q')
# onsR2::download('L87M')
# onsR2::download('L87K')
# onsR2::download('ELBJ')
# onsR2::download('BOPO')
# onsR2::download('BQAU')
# onsR2::download('ELBH')
# onsR2::download('BOPP')
# onsR2::download('BQAV')
# onsR2::download('ELBI')
# onsR2::download('BPAN')
# onsR2::download('BQBD')
# onsR2::download('BQKR')
# onsR2::download('BQKS')
# onsR2::download('ELAY')
# onsR2::download('BPDU')
# onsR2::download('ELAP')
# onsR2::download('BQAA')
# onsR2::download('ELAQ')
# onsR2::download('BQAB')
# onsR2::download('ELAR')
# onsR2::download('BQAI')
# onsR2::download('CHNQ')
# onsR2::download('CHNY')
# onsR2::download('CHNF')
# onsR2::download('ENYL')
# onsR2::download('ENYP')
# onsR2::download('ENYT')
# onsR2::download('ENYO')
# onsR2::download('ENYS')
# onsR2::download('ENYW')
# onsR2::download('CHNS')
# onsR2::download('CHOA')
# onsR2::download('CHNH')
# onsR2::download('CHNO')
# onsR2::download('CHNW')
# onsR2::download('CHOE')
# onsR2::download('CHNP')
# onsR2::download('CHNX')
# onsR2::download('CHNE')
# onsR2::download('CHNV')
# onsR2::download('CHOD')
# onsR2::download('CHNM')
# onsR2::download('CHNA')
# onsR2::download('CHND')
# onsR2::download('CHVI')
# onsR2::download('EOBC')
# onsR2::download('EOBW')
# onsR2::download('EOCQ')
# onsR2::download('ERDN')
# onsR2::download('ERDZ')
# onsR2::download('EREL')
# onsR2::download('ERDG')
# onsR2::download('ERDS')
# onsR2::download('EREE')
# onsR2::download('EOBD')
# onsR2::download('EOBX')
# onsR2::download('EOCR')
# onsR2::download('EPLX')
# onsR2::download('EPMX')
# onsR2::download('EPNX')
# onsR2::download('ERDM')
# onsR2::download('ERDY')
# onsR2::download('EREK')
# onsR2::download('EPLV')
# onsR2::download('EPMV')
# onsR2::download('EPNV')
# onsR2::download('J9C5')
# onsR2::download('J9C6')
# onsR2::download('J9C4')
# onsR2::download('K244')
# onsR2::download('K38E')
# onsR2::download('JQZ3')
# onsR2::download('JQZ2')
# onsR2::download('JQY9')
# onsR2::download('JQ98')
# onsR2::download('JQX5')
# onsR2::download('JQX6')
# onsR2::download('JQX7')
# onsR2::download('JQX8')
# onsR2::download('JQX9')
# onsR2::download('JQY2')
# onsR2::download('L2KL')
# onsR2::download('L2KR')
# onsR2::download('L2KX')
# onsR2::download('L2MW')
# onsR2::download('L2N2')
# onsR2::download('L2N8')
# onsR2::download('L2PZ')
# onsR2::download('KI8M')
# onsR2::download('KI8O')
# onsR2::download('KI8Q')
# onsR2::download('YBEZ')
# onsR2::download('KLH7')
# onsR2::download('L2KQ')
# onsR2::download('L2NC')
# onsR2::download('JQR3')
# onsR2::download('JQS7')
# onsR2::download('JQU3')
# onsR2::download('JQU4')

#http://www.ons.gov.uk/generator?format=csv&uri=/economy/nationalaccounts/balanceofpayments/timeseries/bqbd/mret
#http://www.ons.gov.uk/generator?format=csv&uri=/economy/nationalaccounts/balanceofpayments/timeseries/bqbd/mret
