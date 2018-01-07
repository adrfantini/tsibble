% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/as-tsibble.R
\name{tsibble}
\alias{tsibble}
\title{Create a tsibble object}
\usage{
tsibble(..., key = id(), index, regular = TRUE)
}
\arguments{
\item{...}{A set of name-value pairs. The names of "key" and "index" should
be avoided as they are used as the arguments.}

\item{key}{Structural variable(s) that define unique time indices, used with
the helper \link{id}. If a univariate time series (without an explicit key),
simply call \code{id()}. See below for details.}

\item{index}{A bare (or unquoted) variable to specify the time index variable.}

\item{regular}{Regular time interval (\code{TRUE}) or irregular (\code{FALSE}). \code{TRUE}
finds the minimal time span as the interval.}
}
\value{
A tsibble object.
}
\description{
Create a tsibble object
}
\details{
A valid tsibble does not arrange the index in the time order.
Please use \link{arrange} to get the order by time.
}
\section{Index}{

The time indices are no longer an attribute (for example, the \code{tsp} attribute
in a \code{ts} object), but preserved as the essential component of the tsibble. A
few index classes, such as \code{Date}, \code{POSIXct}, and \code{difftime}, forms the basis of
the tsibble, with new additions \link{yearmonth} and \link{yearquarter} representing
year-month and year-quarter respectively. \code{zoo::yearmth} and \code{zoo::yearqtr}
are also supported. It is extensible to work with custom index, for example
trading days and weekly data.
}

\section{Key}{

Key variable(s) together with the index uniquely identifies each record. And
key(s) also imposes the structure on a tsibble, which can be created via the
\link{id} function as identifiers:
\itemize{
\item None: an implicit variable \code{id()} resulting a univariate time series.
\item A single variable: an explicit variable. For example, \code{data(pedestrian)}
uses the \code{id(Sensor)} column as the key.
\item Nested variables: a nesting of one variable under another. For example,
\code{data(tourism)} contains two geographical locations: \code{Region} and \code{State}.
\code{Region} is the lower level than \code{State} in Australia; in other words, \code{Region}
is nested into \code{State}, which naturally forms a hierarchy. A vertical bars (\code{|})
is used to describe this nesting relationship, and thus \code{Region} | \code{State}.
In theory, nesting can involve infinite levels, so is \code{tsibble}.
\item Crossed variables: a crossing of one variable with another. For example,
the geographical locations are crossed with the purpose of visiting (\code{Purpose})
in the \code{data(tourism)}. A comma (\code{,}) is used to indicate this crossing
relationship. Nested and crossed variables can be combined, such as
\code{data(tourism)} using \code{id(Region | State, Purpose)}.
}

These key variables are descriptors, not values.
}

\section{Interval}{

The \link{interval} function returns the interval associated with the tsibble.
\itemize{
\item Regular: the value and its time unit including "second", "minute", "hour",
"day", "week", "month", "quarter", "year". An unrecognisable time interval is
labelled as "unit".
\item Irregular: \code{as_tsibble(regular = FALSE)} gives the irregular tsibble. It is
marked with \code{!}.
\item Unknown: if there is only one entry for each key variable, the interval
cannot be determined (\code{?}).
}
}

\examples{
# create a tsibble w/o a key ----
tbl1 <- tsibble(
  date = seq(as.Date("2017-01-01"), as.Date("2017-01-10"), by = 1),
  value = rnorm(10),
  key = id(), index = date
)

# create a tsibble with one key ----
tbl2 <- tsibble(
  qtr = rep(yearquarter(seq(2010, 2012.25, by = 1/ 4)), 3),
  group = rep(c("x", "y", "z"), each = 10),
  value = rnorm(30),
  key = id(group), index = qtr
)

}