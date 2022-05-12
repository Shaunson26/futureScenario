test_that('stopifnot works', {

  expect_error(return_address_coords(street_number = 'a'))
  expect_error(return_address_coords(postcode = 'a'))
  expect_error(return_address_coords(postcode = 12345))
  expect_error(return_address_coords(postcode = 123))

})

test_that('return_address_coords works', {

  res <- return_address_coords(street_number = 2, street_name = 'IVY STREET', locality = 'DARLINGTON', postcode = '2008')

  expect_length(res, 6)
  expect_length(nrow(res), 1)

  res <- return_address_coords(street_name = 'IVY STREET', locality = 'DARLINGTON', street_number = 2, postcode = '2008')

  expect_length(res, 6)
  expect_length(nrow(res), 1)

  res <- return_address_coords('1', 'A', 'B', 2000)

  expect_length(res, 6)
  #expect_(nrow(res), 0)


  expect_error(return_address_coords(1, 'A', 'B', 20000))
  expect_error(return_address_coords(1, 'A', 'B', '2000A'))

  # return_address_coords(1, 1, 'B', 2)
  # return_address_coords(1, 'A', 1, 2)
  # return_address_coords(1, 'A', 'B', 'C')
  # return_address_coords(1, 'A', 'B')
  # return_address_coords(street_name = 'A', locality = 'B', postcode = 2)
  # return_address_coords(street_number = 1, locality = 'B', postcode = 2)
  # return_address_coords(street_number = 1, street_name = 'A', postcode = 2)
})

