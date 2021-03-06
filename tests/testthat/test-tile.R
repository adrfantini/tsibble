context("Tiling window function and its variants")

x <- 1:5
y <- 6:10
z <- 11:15
lst <- list(x = x, y = y, z = z)
df <- as.data.frame(lst)
lst_cols <- tibble::tibble(lst = list(df, df, df))

test_that("tiler() & ptiler()", {
  expect_equal(tiler(x, .size = 2), list(1:2, 3:4, 5))
  expect_equal(
    tiler(lst, .size = 2),
    list(list(x = x, y = y), list(z = z))
  )
  expect_equal(
    tiler(list(x, y), .size = 2),
    list(list(x, y))
  )
  expect_equal(
    ptiler(lst, .size = 2),
    list(list(list(x = x, y = y), list(z = z)))
  )
  expect_equal(
    ptiler(list(x, y), list(y), .size = 2),
    list(list(list(x, y)), list(list(y, y)))
  )
  expect_equal(
    ptiler(as.list(df), .size = 2),
    ptiler(lst, .size = 2)
  )
  expect_equal(
    tiler(list(x = 1.5, y = 1L), .size = 2, .bind = TRUE),
    list(c(1.5, 1.0))
  )
})

test_that("tile() and its variants", {
  expect_equal(
    tile_dbl(x, mean, .size = 2),
    purrr::map_dbl(tiler(x, 2), mean)
  )
  expect_equal(
    tile(lst, ~ ., .size = 2),
    list(list(x = x, y = y), list(z = z))
  )
  expect_equal(
    tile_dfr(x, ~ data.frame(x = .), .size = 1),
    data.frame(x = x)
  )
  expect_equal(
    tile_dfc(x, ~ data.frame(x = .), .size = 1),
    data.frame(x = 1, x1 = 2, x2 = 3, x3 = 4, x4 = 5)
  )
  expect_equal(
    tile_dfr(x, quantile, 0.5, .size = 2),
    tibble::tibble(`50%` = tile_dbl(x, quantile, 0.5, .size = 2))
  )
})

test_that("tile2() and its variants", {
  expect_equal(
    tile2_int(x, y, sum, .size = 2),
    c(16L, 24L, 15L)
  )
  expect_equal(
    tile2(lst, lst, ~ ., .size = 2),
    list(list(x = x, y = y), list(z = z))
  )
  expect_equal(
    tile2_dfr(x, y, ~ tibble::tibble(x = .x + .y), .size = 1)[1, 1, drop  = TRUE],
    7
  )
  expect_equal(
    tile2_dfc(x, y, ~ tibble::tibble(x = .x + .y), .size = 1)[1, 1, drop  = TRUE],
    7
  )
})

test_that("ptile() and its variants", {
  expect_equal(
    ptile_lgl(lst, ~ sum(..1, ..2) > 10, size = 1),
    ptile_int(lst, ~ sum(..1, ..2), size = 1) > 10
  )
  expect_equal(
    ptile(list(lst, lst), ~ ..1, .size = 2),
    list(list(x = x, y = y), list(z = z))
  )
  expect_equal(
    ptile(list(list(x, y), list(y)), ~ list(..1, ..2)),
    ptile(list(list(x, y), list(y, y)), ~ list(..1, ..2))
  )
  my_sum2 <- function(...) {
    data <- list(...)
    data.frame(x = sum(data$x))
  }
  expect_equal(
    ptile_dfr(df, my_sum2, .size = 2),
    data.frame(x = c(3L, 7L, 5L))
  )
  expect_equal(
    ptile_dfc(df, my_sum2, .size = 2),
    data.frame(x = 3L, x1 = 7L, x2 = 5L)
  )
})
