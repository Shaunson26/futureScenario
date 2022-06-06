load('data/gnaf.rda')

library(dplyr)


tmp <- readr::read_csv('inst/extdata/merged_addresses.csv', col_types = 'c')
tmp2 <- tmp[1:7,]

tmp2

# Remove leading characters
tmp2$FullAddress2 <- sub('[[:alpha:]]+[ ]*([[:digit:]])', '\\1', tmp2$FullAddress)
tmp2

# Split unit and lots
tmp2$FullAddress3 <- sub('([[:digit:]]+)[/ ]([[:digit:]])|^', '\\1|\\2', tmp2$FullAddress2)
tmp2

# ST -> SAINT
tmp2$FullAddress4 <- tmp2$FullAddress3

for(i in 1:nrow(saint_replacements)){
  tmp2$FullAddress4 <-
    sub(pattern = saint_replacements$name[i],
        replacement = 'SAINT\\2',
        x = tmp2$FullAddress4,
        ignore.case = T)
}

tmp2$FullAddress4

# Sreet abbreviations
tmp2$FullAddress5 <- tmp2$FullAddress4

for(i in 1:nrow(street_replacements)){
  tmp2$FullAddress5 <-
    sub(pattern = create_regex(street_replacements$short[i]),
        replacement = paste0(' ', street_replacements$full[i], ' '),
        x =  tmp2$FullAddress5,
        ignore.case = T)
}

tmp2

for(x in unique(street_replacements$full)){
  tmp2$FullAddress5 <-
    sub(pattern = create_regex(x),
        replacement = paste0(' ', x, '|'),
        x =  tmp2$FullAddress5,
        ignore.case = T)
}

tmp2$FullAddress5

# Locality
# Space in locality
tmp2$FullAddress6 <- sub('(.*)(\\d{4})(.*)', '\\1|\\2|\\3', tmp2$FullAddress5)

t(tmp2)
