Discounts <- function(freqs) {
    # Discounts based on n-gram frequencies of frequencies as per Ney et al - 1994
    D <- vector(length = length(freqs))
    for (i in 1:length(freqs)) {
        # Get frequencies of friequencies
        FF <- table(freqs[[i]])
        D[i] <- FF[1]/(FF[1] + 2 * FF[2])        
    }
    D    
}
Disc <- Discounts(freqs)

P_kn <- function(prefix, word, lower_order=FALSE) {
# Kneser-Ney Probability Function
    
    prefix_words <- unlist(strsplit(prefix," "))
    n <- length(prefix_words) + 1
    D <- Disc[n]
    # Base case: -
    if (n == 1) {
        # Return contination counts divided by number of bigram types: -
        C__ <- length(freqs[[2]])
        return(bi_cont[word]/C__)
    } else {
        # Recursive case: -
        # If highest order n-gram: -
        if (!lower_order) {
            # Use absolute count: -
            ind <- grepl(paste0('^',prefix,' ',word,'$'), names(freqs[[n]]))
            C_w <- sum(freqs[[n]][ind])
            ind <- grepl(paste0('^',prefix,' '), names(freqs[[n]]))
            C__ <- sum(freqs[[n]][ind])
        } else {
            # Use continuation count: -
            # All rows of higher n-gram which have the form *_prefix_word
            ind <- grepl(paste0('^[^ ]+ ',prefix,' ',word,'$'), names(freqs[[n+1]]))
            C_w <- sum(ind)
            # All rows of higher n-gram which have the form *_prefix_*
            ind <- grepl(paste0('^[^ ]+ ',prefix,' '), names(freqs[[n+1]]))
            C__ <- sum(ind)
        }        
        if (C__ == 0) {
            # prefix is unseen so backoff to lower order with weight of 1
            prefix <- gsub('^[^ ]+ *', '', prefix)
            return(Predict_kn(prefix, word, lower_order=TRUE))
        } else {
            # To calculate part of interpolating factor (chen-goodman 2.6):
            Cw_ <- sum(grepl(paste0('^', prefix, ' '), names(freqs[[n]])))
            prefix <- gsub('^[^ ]+ *', '', prefix)
            lambda <- D * Cw_ / C__
            return( max( C_w - D, 0)/C__ + lambda * P_kn(prefix, word, lower_order=TRUE) )
            
        }
    }          
}

P_kn("one of these", "things")


