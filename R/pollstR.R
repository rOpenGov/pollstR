pollstR <- function(chart="2012-general-election-romney-vs-obama", pages=1) {
    dat <- data.frame()
    if (pages=="all") { pages <- Inf }
    fin <- FALSE
    pnum <- 1
    while ((pnum <= pages) & !fin) {
        fname <- paste("http://elections.huffingtonpost.com/pollster/api/polls.xml",
                       "?chart=",chart,"&page=",pnum,sep="")
        xmltree <- tryCatch(xmlTreeParse(fname,error=NULL),XMLError=function(e) {NULL} )
        if (is.null(xmltree)) {
            cat("Alert: Chart [",chart,"] does not exist.\n")
            dat <- NULL
            fin <- TRUE
        } else {
            r <- xmlRoot(xmltree)
            if (r$name=="nil_classes") {
                fin <- TRUE
                if (pages != Inf) { cat("Alert: Page",pnum,"contained zero polls, stopping.\n") }
            } else {
                for (i in 1:length(r)) {
                    poll.raw <- as.list(xmlSApply(r[[i]], xmlValue))
                    poll <- data.frame(id=as.numeric(poll.raw$id),pollster=poll.raw$pollster,start.date=poll.raw$start_date,
                                       end.date=poll.raw$end_date,method=poll.raw$method)
                    nq <- length(r[[i]][['questions']])
                    if (nq>1) {
                        qvec <- NULL
                        for (j in 1:length(r[[i]][['questions']])) {
                            qvec <- c(qvec,ifelse(is.null(r[[i]][['questions']][[j]][['chart']][['text']]$value),
                                                  NA,r[[i]][['questions']][[j]][['chart']][['text']]$value))
                        }
                        qindex <- which(qvec %in% chart)
                    } else {
                        qindex <- 1
                    }
                    sp <- r[[i]][['questions']][[qindex]][['subpopulations']][[1]]
                    qinfo <- xmlSApply(sp,function(x) xmlSApply(x, xmlValue))
                    poll$subpop <- qinfo$name
                    poll$N <- ifelse(is.list(qinfo$observations),NA,as.numeric(qinfo$observations))
                    res <- xmlSApply(sp[['responses']],function(x) xmlSApply(x, xmlValue))
                    resvals <- data.frame(matrix(as.numeric(c(as.character(poll$id),res[2,])),nrow=1))
                    names(resvals) <- c("id",res[1,])
                    poll <- merge(poll,resvals)
                    dat <- rbind.fill(dat,poll)
                }
                dat$start.date <- as.Date(dat$start.date)
                dat$end.date <- as.Date(dat$end.date)
                pnum <- pnum+1
            }
        }
    }
    return(dat)
}
