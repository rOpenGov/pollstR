getpolls <- function(chart=NULL, topic=NULL, state=NULL, 
                     before=NULL, after=NULL, sort=TRUE,
                     topic_check=TRUE,
                     return_all=TRUE, page=NULL, fmt='json', ...) {
    params <- '?'
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
    
    if(return_all){
        if(!is.null(page))
            warning("'page' ignored because 'return_all=TRUE'")
        
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
                p <- p + 1
            }
        }
        message(paste(p-1,"pages returned."))
        
        # parse `parsed` object and return
        if(fmt=='json'){
            #out <- fromJSON(response)
            out <- lapply(response, function(x) fromJSON(x)[[1]])
        } else if (fmt=='xml') {
            #out <- xmlToList(xmlParse(response), addAttributes=FALSE)
            out <- response
        }
        
        
        if(FALSE){
            
            
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
        
    } else {
        params <- paste(params,if(nchar(params)>1) '&' else '','page=',page,sep='')
        url <- paste('http://elections.huffingtonpost.com/pollster/api/polls.',
                    fmt,params,sep='')
        response <- paste(readLines(url, warn=FALSE), collapse='')
        if(fmt=='json'){
            #out <- fromJSON(response)
            out <- response
        } else if (fmt=='xml') {
            #out <- xmlToList(xmlParse(response), addAttributes=FALSE)
            out <- response
        }
    }
    return(out)
}
