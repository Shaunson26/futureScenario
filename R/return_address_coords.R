#' Query the flat minified GNAF dataset
#'
#' A filter dplyr::filter function on the columns in \code{gnaf}. Missing values
#' will return a T in the filter step, essentially meaning 'everything' for that
#' column
#'
#' @param street_number street number without any unit/apartment info
#' @param street_name street name
#' @param locality locality/suburb
#' @param postcode postcode. Must be 4 digits
#'
#' @export
return_address_coords <- function(street_number, street_name, locality, postcode){

  # Input checking ----

  stopifnot(
    'street_number cannot have characters' = !grepl('\\D', street_number),
    'postcode cannot have characters' = !grepl('\\D', postcode),
    'postcode must be 4 digits in length' = nchar(postcode) == 4
  )

  street_number <- as.numeric(street_number)
  postcode <- as.numeric(postcode)


  stopifnot(
    'street_number must be a number' = ifelse(missing(street_number), T, is.numeric(street_number)),
    'street_name must be a character' = ifelse(missing(street_name), T, is.character(street_name)),
    'locality must be a character' = ifelse(missing(locality), T, is.character(locality)),
    'postcode must be a number' =  ifelse(missing(postcode), T, is.numeric(postcode))
  )

  # Function ----
  missing_street_number = ifelse(missing(street_number), T, F)
  missing_street_name = ifelse(missing(street_name), T, F)
  missing_locality = ifelse(missing(locality), T, F)
  missing_postcode = ifelse(missing(postcode), T, F)

  # [to-do] to upper, partial matching

  dplyr::filter(gnaf,
                if (missing_street_number) T else NUMBER_FIRST == street_number,
                if (missing_street_name) T else STREET_NAME == street_name,
                if (missing_locality) T else LOCALITY_NAME == locality,
                if (missing_postcode) T else POSTCODE == postcode)
}

#return_address_coords(1, 'A', 'B', 2000)
# return_address_coords('1', 'A', 'B', 2000)
# return_address_coords('A1', 'A', 'B', 2000)
# return_address_coords(1, 'A', 'B', 20000)
# return_address_coords(1, 'A', 'B', '2000')
# return_address_coords(1, 'A', 'B', '2000A')
# return_address_coords(1, 1, 'B', 2)
# return_address_coords(1, 'A', 1, 2)
# return_address_coords(1, 'A', 'B', 'C')
# return_address_coords(1, 'A', 'B')
# return_address_coords(street_name = 'A', locality = 'B', postcode = 2)
# return_address_coords(street_number = 1, locality = 'B', postcode = 2)
# return_address_coords(street_number = 1, street_name = 'A', postcode = 2)

