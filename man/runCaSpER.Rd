% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/segmentation.R
\name{runCaSpER}
\alias{runCaSpER}
\title{runCaSpER()}
\usage{
runCaSpER(object, removeCentromere = T, cytoband = object@cytoband,
  method = "iterative")
}
\arguments{
\item{object}{casper object}

\item{removeCentromere}{boolean values determining if centromere regions should be removed from the analysis}

\item{cytoband}{cytoband information downloaded from UCSC hg19: http://hgdownload.cse.ucsc.edu/goldenpath/hg19/database/cytoBand.txt.gz hg38:http://hgdownload.cse.ucsc.edu/goldenpath/hg38/database/cytoBand.txt.gz}

\item{method}{iterative or fixed method. Fixed performs CNV calls on desired baf and expression scale whereas iterative performs pairwise comparison of all expression and baf scale pairs. Iterative method is recommendend. (default: iterative)}
}
\value{
list of objects
}
\description{
Main casper function that performs a pairwise comparison of all scales from BAF and expression signals to ensure a coherent set of CNV calls.
}
