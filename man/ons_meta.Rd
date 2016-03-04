\name{ons_ts_meta}
\alias{ons_ts_meta}
\title{R6 class for scraping ONS meta data}
\usage{
ons_ts_meta()
}
\description{

 This class scraps the meta data from ONS website
 There are 2 kinds of meta data; \code{Timeseries} and \code{Dataset}
 SelectorGadget (from selectorgadget.com) was use to find the required selectors (\code{base_css})
 The ONS site is new and bound to undergo changes so should watch out for changes in base_murl and base_css

 The meta information are stored in 2 tables in sqlite database \code{ons_timeseries} and \code{ons_datasets}.

 \code{ons_timeseries} = has 3 colums (\code{code}, \code{caption}, \code{url})
 The codes in \code{code} in code are unique and the the \code{url} points to csv files containing the actual time
 series data.

 \code{ons_datasets} has an additional column name \code{url_csv}. In this dataset it is rather the \code{url_csv}
 instead of \code{url} which points to csv file containing the actual data.
}
\examples{
ons_ts_meta()
}
