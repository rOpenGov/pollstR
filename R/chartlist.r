chartlist <- function(topic=NULL, state=NULL, topic_check=TRUE, fmt='json', ...) {
    params <- '?'
    if(!is.null(state))
        params <- paste(params,'state=',state,sep='')
    if(!is.null(topic)){
        allowed <- c('obama-job-approval', '2016-president', '2016-gop-primary',
                     '2014-senate', '2014-house', '2014-governor', '2013-senate',
                     '2013-house', '2013-governor', '2012-senate', '2012-president',
                     '2012-house', '2012-governor', '2012-gop-primary')
        if(topic_check && !topic %in% allowed)
            stop(paste("topic must be one of:",paste(allowed,collapse=', ')))
        params <- paste(params,if(nchar(params)>1) '&' else '','topic=',topic,sep='')
    }
    url <- paste('http://elections.huffingtonpost.com/pollster/api/charts.',
                 fmt,params,sep='')
    if(fmt=='json'){
        response <- paste(readLines(url, warn=FALSE), collapse='')
        json <- fromJSON(response, nullValue=NA)
        out <- do.call(rbind.data.frame, lapply(json, function(x) x[1:8]))
        estimates <- lapply(json, `[`, 'estimates')
        
        estout <- lapply(estimates, function(x) {
            if(!is.null(x[[1]]))
                do.call(rbind.data.frame, x[[1]])
            else
                NULL
        })
        names(estout) <- out$slug
    } else if(fmt=='xml'){
        response <- paste(readLines(url, warn=FALSE), collapse='')
        parsed <- xmlParse(response)
        out <- xmlToDataFrame(parsed)
        out$estimates <- NULL
        estimates <- xpathApply(parsed, '//estimates')
        estout <- lapply(estimates, function(x) {
            x <- xmlToList(x)
            if(!is.null(x))
                do.call(rbind,x)
            else
                NULL
        })
        names(estout) <- out$slug
    } else
        stop("'fmt' must be 'xml' or 'json'")
    row.names(out) <- 1:nrow(out)
    out$estimates <- estout
    class(out) <- c('pollsterchartlist',class(out))
    return(out)
}

print.pollsterchartlist <- function(x,...){
    ests <- sapply(x$estimates, function(z){
        if(is.null(z)) FALSE else nrow(z) > 0
    })
    print(cbind.data.frame(x[,c('title','slug','state','poll_count','last_updated')],
          estimates=ests), right=FALSE)
    return(invisible(x))
}
