\name{search_code}
\alias{search_code}
\title{
Searches the meta-data of the ONS database using friendly words like GDP, CPI
}

\description{
Searches the meta-data of the ONS database using friendly words like GDP, CPI , France
}
\usage{
search_code(qry, is_code = FALSE)
}

\arguments{
  \item{qry}{
 search string
}
  \item{is_code}{
   TRUE if 4-letter code should be searched
  }
}

\value{
 \item{data frame}{
 with headings \code{code, description} and \code{dataset}}
}
\author{
 E Amoakohene
}

\examples{
# search("GDP")
# search("rpi")
# search("ABMI",is_code=TRUE)
}
