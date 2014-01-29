getchart <- function(chart, fmt='json', ...){
    if(is.null(chart))
        stop("Must specify named chart")
    if(!fmt %in% c('json','xml'))
        stop("fmt must be 'json' or 'xml'")
    url <- paste('http://elections.huffingtonpost.com/pollster/api/charts/',
                    as.character(chart),'.',fmt,sep='')
    response <- paste(readLines(url, warn=FALSE), collapse='')
    
    if(fmt=='json'){
        out <- fromJSON(response)
        out$estimates <- data.frame(do.call(rbind,out$estimates))
        rownames(out$estimates) <- 1:nrow(out$estimates)
        if('estimates_by_date' %in% names(out)){
            m <- lapply(out$estimates_by_date, function(x){
                setNames(c(x$date, sapply(x$estimates, `[`, 'value')),
                c('date', sapply(x$estimates, `[`, 'choice')))
            })
            out$estimates_by_date <- do.call(rbind.fill, lapply(m, as.data.frame))
        }
    } else if (fmt=='xml') {
        out <- xmlToList(xmlParse(response), addAttributes=FALSE)
        out$estimates <- do.call(rbind.data.frame,out$estimates)
        rownames(out$estimates) <- 1:nrow(out$estimates)
        out$poll_count <- as.numeric(out$poll_count)
    }
    return(out)
}
