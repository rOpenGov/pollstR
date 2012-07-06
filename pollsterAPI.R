## 
## Drew Linzer
## dlinzer@gmail.com
## July 6, 2012
## 
## pollsterAPI.R
## 
## R interface for HuffingtonPost-Pollster API
## http://elections.huffingtonpost.com/pollster/api
## 

## API access function (must be connected to Internet)

pollstR <- function(chart="2012-general-election-romney-vs-obama",pages=1) {
    # requires library(XML) and library(reshape)
    # chart: 2012-general-election-romney-vs-obama, us-right-direction-wrong-track, obama-favorable-rating,
    #        mitt-romney-favorability, obama-job-approval, obama-job-approval-economy, obama-job-approval-health,
    #        congress-job-approval, 2012-national-house-race
    # pages: number of pages of poll results to read. 10 polls per page, default is 1 most recent page.
    dat <- data.frame()
    for (pnum in 1:pages) {
        fname <- paste("http://elections.huffingtonpost.com/pollster/api/polls.xml",
                       "?chart=",chart,"&page=",pnum,sep="")
        r <- xmlRoot(xmlTreeParse(fname))
        for (i in 1:length(r)) {
            poll <- as.data.frame(t(xmlSApply(r[[i]], xmlValue)))[-c(6:7)]
            nq <- length(names(r[[i]][['questions']]))
            if (nq==1) {
                res <- xmlSApply(r[[i]][['questions']][['question']][['responses']], function(x) xmlSApply(x, xmlValue))
            } else {
                qvec <- NULL
                for (j in 1:length(r[[i]][['questions']])) {
                    qvec <- c(qvec,ifelse(is.null(r[[i]][['questions']][[j]][['chart']][['text']]$value),
                                          NA,r[[i]][['questions']][[j]][['chart']][['text']]$value))
                }
                res <- xmlSApply(r[[i]][['questions']][[which(qvec %in% chart)]][['responses']], function(x) xmlSApply(x, xmlValue))
            }
            poll$subpop <- res[3,1]
            poll$N <- as.numeric(res[4,1])
            resvals <- data.frame(matrix(as.numeric(c(as.character(poll$id),res[2,])),nrow=1))
            names(resvals) <- c("id",res[1,])
            poll <- merge(poll,resvals)
            dat <- rbind.fill(dat,poll)
        }
    }
    dat$start_date <- as.Date(dat$start_date)
    dat$end_date <- as.Date(dat$end_date)
    return(dat)
}

## try it out...

library(XML)
library(reshape)

dat <- pollstR()

dat.ca <- pollstR(chart="2012-california-president-romney-vs-obama")

# end of file
