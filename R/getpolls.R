getpolls <- function(chart=NULL, topic=NULL, state=NULL, 
                     before=NULL, after=NULL, sort=TRUE,
                     topic_check=TRUE, page=NULL, 
                     return_all=FALSE, fmt='json', ...) {
    params <- '?'
    if(!is.null(chart))
        params <- paste(params,'chart=',as.character(chart),sep='')
    if(!is.null(topic)){
        allowed <- c('obama-job-approval', '2016-president', '2016-gop-primary',
                     '2014-senate', '2014-house', '2014-governor', '2013-senate',
                     '2013-house', '2013-governor', '2012-senate', '2012-president',
                     '2012-house', '2012-governor', '2012-gop-primary')
        if(topic_check && !topic %in% allowed)
            stop(paste("topic must be one of:",allowed))
        params <- paste(params,if(nchar(params)>1) '&' else '','topic=',topic,sep='')
    }
    if(!is.null(state))
        params <- paste(params,if(nchar(params)>1) '&' else '','state=',state,sep='')
    if(!is.null(before)){
        before <- as.Date(before, '%Y-%m-%d')
        if(is.na(before))
            stop("'before' is not in YYYY-MM-DD format")
        params <- paste(params,if(nchar(params)>1) '&' else '','before=',before,sep='')
    }
    if(!is.null(after)){
        after <- as.Date(after, '%Y-%m-%d')
        if(is.na(after))
            stop("'after' is not in YYYY-MM-DD format")
        params <- paste(params,if(nchar(params)>1) '&' else '','after=',after,sep='')
    }
    if(sort)
        params <- paste(params,if(nchar(params)>1) '&' else '','sort=updated',sep='')
    if(!is.null(page) & return_all)
        warning("'page' ignored because 'return_all=TRUE'")
    
    
    # function to parse JSON response
    jsonpolls <- function(z) {}
    
    # function to parse XML response
    if(FALSE){
        xmlpolls <- function(z) {
            p <- xmlParse(z)
            zout <- xmlToDataFrame(p)
            zout$questions <- NULL # delete terrible parsing
            zout <- cbind(zout,
            do.call(rbind, xpathApply(p, '//subpopulations', function(node){
                nodeout <- xmlToDataFrame(node)
                nodeout$responses <-
                    xmlToDataFrame(xmlChildren(xmlChildren(node)[[1]])$response)
                names(nodeout)[names(nodeout)=='name'] <- 'subpopulation'
                return(nodeout)
                
            })))
            return(zout)
        }
        dat <- data.frame() 
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
        return(dat)
    }
    
    
    if(return_all){
        p <- 1
        response <- list()
        url <- paste('http://elections.huffingtonpost.com/pollster/api/polls.',
                         fmt,params,sep='')
        repeat {
            url <- paste(url,if(nchar(params)>1) '&' else '','page=',p,sep='')
            r <- paste(readLines(url, warn=FALSE), collapse='')
            if(fmt=='xml' && grepl('nil_classes',r))
                break
            else if(fmt=='json' && r=='[]')
                break
            else {
                response[[p]] <- r
                message(paste('Page',p,'of polls retrieved'))
                p <- p + 1
            }
        }
        message(paste(p-1,"pages returned."))
        if(fmt=='json'){
            #out <- lapply(response, jsonpolls)
            out <- lapply(response, function(x) fromJSON(x)[[1]])
        } else if (fmt=='xml') {
            out <- lapply(response, xmlpolls)
            #out <- response
        }
    } else {
        params <- paste(params,if(nchar(params)>1) '&' else '','page=',page,sep='')
        url <- paste('http://elections.huffingtonpost.com/pollster/api/polls.',
                    fmt,params,sep='')
        response <- paste(readLines(url, warn=FALSE), collapse='')
        if(fmt=='json'){
            #out <- jsonpolls(response)
            out <- fromJSON(response)
        } else if (fmt=='xml') {
            #out <- xmlpolls(response)
            out <- response
        }
    }
    class(out) <- c('pollsterpolls', class(out))
    return(out)
}
