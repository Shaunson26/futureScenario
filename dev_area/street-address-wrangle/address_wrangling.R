# * Transform shorthand streets to long
create_regex <- function(x){
  paste0(' ', x, '[ ,\\.]| ', x, '$')
}

street_replacements <-
  tibble::tribble(
    ~short, ~full,
    'AVE', 'AVENUE',
    'AV', 'AVENUE',
    'BLVD', 'BOULEVARD',
    'BVD', 'BOULEVARD',
    'CIR', 'CIRCLE',
    'CCT', 'CIRCUIT',
    'CT', 'COURT',
    'CL', 'CLOSE',
    'CLS','CLOSE',
    'CRT', 'COURT',
    'CR','CRESCENT',
    'CRE','CRESCENT',
    'CRS','CRESCENT',
    'CRES', 'CRESCENT',
    'DR', 'DRIVE',
    'DRV', 'DRIVE',
    'ESP','ESPLANADE',
    'GR' ,'GROVE',
    'HWY','HIGHWAY',
    'LN','LANE',
    'PDE','PARADE',
    'PKWY', 'PARKWAY',
    'PL','PLACE',
    'RDG','RIDGE',
    'RD','ROAD',
    'SQ',	'SQUARE',
    'ST','STREET',
    'STRAIGHT', 'STRAIGHT',
    'TCE','TERRACE',
    'TLE', 'TERRACE')


# ST to SAINT
saint_replacements <-
  tibble::tribble(
    ~name,
    '(ST)( KILDA)',
    '(ST)( IVES)',
    '(ST)( ALBANS)',
    '(ST)( CLAIR)',
    '(ST)( PAULS)')
