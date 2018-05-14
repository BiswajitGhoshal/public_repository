make.dtm <- function(y) {
    library(tidyverse)
    library(tidytext)
    require(magrittr)
    require(text2vec)
    require(stringr)
    require(Matrix)
    
    year_file <- readRDS(paste0("bd.df.30firms.",y,".Rds"))
    year_file$cik <- sapply(strsplit(year_file$file, "_"),'[[',1)
    
    year_file$bd.text <- year_file$bd.text %>%
        str_replace_all("[^[:alnum:]]", " ") %>%  # remove non-alphanumeric symbols
        str_replace_all("\\s+", " ")  # collapse multiple spaces into one space 
    
    a <- year_file %>% unnest_tokens(word, bd.text, to_lower = TRUE) %>% 
        anti_join(stop_words) %>% # remove the stop words
        count(cik, word, sort = TRUE)  %>% # count for each document how many times each word appears
        ungroup() %>% 
        cast_dtm(cik, word, n)
    return(a) }
