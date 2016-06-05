library(tm)
load("./data/freqs10.Rda")
load("./data/bi_cont.Rda")
Discounts <- function(freqs) {
    # Discounts based on n-gram frequencies of frequencies as per Ney et al - 1994
    D <- vector(length = length(freqs))
    for (i in 1:length(freqs)) {
        # Get frequencies of friequencies
        if (i > 3) {
            D[i] = D[3]
        } else {
            FF <- table(freqs[[i]])
            D[i] <- FF[1]/(FF[1] + 2 * FF[2])        
        }
    }
    D   
}
Disc <- Discounts(freqs)

merge_add <- function(a,b) {
    # Takes to named numeric vectors and returns a new vector with superset of each's names
    # The values are the sum of the 2 corresponing terms (0 if not present)
    all_names <- union(names(a),names(b))
    v <- vector(length=length(all_names))
    names(v) <- all_names
    for (nm in all_names) {
        a_val <- if (is.na(a[nm])) 0 else a[nm]
        b_val <- if (is.na(b[nm])) 0 else b[nm]
        v[nm] <- a_val + b_val
    }
    v
}

removeMostPunctuation<-function (x) {
    # Assume there are no ASCII 1 or 2 characters.
    x <- gsub("(\\w)-(\\w)", "\\1\1\\2", x)
    x <- gsub("(\\w)'(\\w)", "\\1\2\\2", x)
    x <- gsub("[[:punct:]]+", " ", x)
    x <- gsub("\1", "-", x, fixed = TRUE)
    gsub("\2", "'", x, fixed = TRUE)    
} 
removeDodgy <- function(x) iconv(x, "latin1", "ASCII", sub="")


Do_predict <- function(text) {
    # Preprocess input
    text <- removeDodgy(text)
    text <- removeMostPunctuation(text)
    text <- removeNumbers(text)
    text <- tolower(text)
    text <- stripWhitespace(text)
    # Get most recent words
    F <- length(freqs) - 1
    words <- unlist(strsplit(text," "))
    L <- length(words)
    words <- words[max((L-F+1),1):L]
    # Check they are in Vocab. If not replace with widcard
    words <- sapply(words, function(x) if (x %in% names(freqs[[1]])) x else '[^[:space:]]+')
    words <- paste(words, collapse=" ") 
    Predict_kn(words)    
}




Predict_kn <- function(prefix, lower_order=FALSE) {    
    wlimit <- 10
    pre_words <- unlist(strsplit(prefix," "))
    n <- length(pre_words) + 1
    D <- Disc[n]
    # Base case: -
    if (n == 1) {
        # Return contination counts divided by number of bigram types: -
        C__ <- length(freqs[[2]])
        return(head(bi_cont/C__,wlimit))
    } else {
        # Recursive case: -
        # If highest order n-gram: -
        if (!lower_order) {
            # Use absolute count: -
            ind <- grepl(paste0('^',prefix,' '), names(freqs[[n]]))
            W <- freqs[[n]][ind]
            # Only need last word: -
            names(W) <- gsub( '^.* ','',names(W) )
            C__ <- sum(W)
            # Only need wlimit words: -
            W <- head(W,wlimit)            
        } else {
            # Use continuation count: -
            # All rows of higher n-gram which have the form *_prefix_*
            ind <- grepl(paste0('^[^ ]+ ',prefix,' '), names(freqs[[n+1]]))
            W <- table(gsub('^.* ','',names(freqs[[n+1]][ind]))) # Last words
            W <- head(sort(W, decreasing = TRUE),wlimit)
            # Denominator - count all types with prefix as middle terms
            C__ <- sum(ind)
        }        
        if (C__ == 0) {
            # Prefix is unseen so backoff to lower order with weight of 1
            return(Predict_kn(gsub('^[^ ]+ *', '', prefix), lower_order=TRUE))
        } else {
            # To calculate part of interpolating factor (chen-goodman 2.6):
            Cw_ <- sum(grepl(paste0('^', prefix, ' '), names(freqs[[n]])))
            p <- D * Cw_ / C__
            merge_add(sapply( W - D, function(n) {max(n,0)})/C__,
                      p * Predict_kn(gsub('^[^ ]+ *', '', prefix), lower_order=TRUE) )
            
        }
    }          
}
