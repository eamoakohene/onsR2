
my_example <- function(){

  cat("This is only for testing code snippets and should not be run. Please find something useful to do.")

  return(0)

  add(
    list(
      code = 'cpof',
      title='Public Sector: PSND (ex PS banks ex BoE): GBP million: CPNSA',
      unit = 'GBP million',
      grp = 'pusf',
      url='https://www.ons.gov.uk/economy/governmentpublicsectorandtaxes/publicsectorfinance/timeseries/cpof',
      uri_base = '/economy/governmentpublicsectorandtaxes/publicsectorfinance/',
      uri = '/economy/governmentpublicsectorandtaxes/publicsectorfinance/timeseries/cpof'
     ),
    is_local = T
  )

  load_diop = function(){

    diop <- read.csv("r:/data/diop2.csv", header = T)
    cols <- paste( names(diop),sep="", collapse = ",")

    sql_con = DBI::dbConnect(RSQLite::SQLite(), dbname='R:/packages/onsR2/inst/extdata/onsR2.sqlite')
    RSQLite::dbWriteTable(conn = sql_con, name='diop', value = diop )

    sql_in
    DBI::dbDisconnect(sql_con)

  }
}
