join_sa1 <- function(x){
  dplyr::left_join(x, mb2016_to_sa12016, by = c('MB_2016_CODE' = 'MB_CODE_2016'))
}
