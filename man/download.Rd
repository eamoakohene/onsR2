\name{download}
\alias{download}

\title{
Downloads time series data from UK office for National Statistics (ONS)
}

\description{
 The ONS publishes data in either \code{dataset} format or \code{refernce table} format.
 The \code{dataset} format can be dowload as csv but need to know the 4-letter code of the  series and the specific \code{dataset} the series reside. The package has 19000 4-letter codes together with their corresponding dataset and other meta information. Once a code is specified, the function lookup the corrending dataset and download the series directly from ONS website.
}

\usage{
  download(code, format = "ts")
}

\arguments{
  \item{code}{
     4-letter code for the time series
  }
  \item{format}{
   The format in which the data is returned(ts=time series, df= dataframe)
  }
}


\value{
\item{title}{
  description of time series
}
 \item{m_data }{
     monthly time series (or data frame if \code{format='df'}) data if available or NULL}
 \item{q_data }{
    quarterly time series (or data frame if \code{format='df'}) data if available or NULL}
 \item{y_data }{
   yearly time series (or data frame if \code{format='df'}) data if available or NULL}
}

\author{
E Amoakohene (eamoakohene@gmail.com)
}

\examples{

  #  download("ABMI")             #downloads GDP data in ts-format
  #  download("ABMI",format="df") #downloads GDP data in data frame format
  #  download("CHAY")             #downloads the RPI index

 }

