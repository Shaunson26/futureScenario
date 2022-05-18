test_that('stopifnot works', {

  expect_error(return_address_coords(street_number = 'a'))
  expect_error(return_address_coords(postcode = 'a'))
  expect_error(return_address_coords(postcode = 12345))
  expect_error(return_address_coords(postcode = 123))

})

test_that('return_address_coords works', {

  res <- return_address_coords(street_number = 2, street_name = 'IVY STREET', locality = 'DARLINGTON', postcode = '2008')

  expect_length(res, 7)
  expect_length(nrow(res), 1)

  res <- return_address_coords(street_name = 'IVY STREET', locality = 'DARLINGTON', street_number = 2, postcode = '2008')

  expect_length(res, 7)
  expect_length(nrow(res), 1)

  res <- return_address_coords(street_number = 2)

  expect_length(res, 7)
  expect_gt(nrow(res), 1)

  res <- return_address_coords(street_name = 'IVY STREET')

  expect_length(res, 7)
  expect_gt(nrow(res), 1)

  res <- return_address_coords(locality = 'DARLINGTON')

  expect_length(res, 7)
  expect_gt(nrow(res), 1)

  res <- return_address_coords(postcode = '2008')

  expect_length(res, 7)
  expect_gt(nrow(res), 1)

})

