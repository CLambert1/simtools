# WARNING - Generated by {fusen} from dev/flat_simulate_env.Rmd: do not edit by hand

test_that("generate_resource_layer works", {
  expect_true(inherits(generate_resource_layer, "function"))

  grid <- create_grid()
  env_condition <- generate_env_layer(grid = grid)

  expect_error(
    object = generate_resource_layer(env_layers = env_condition$dataframe, beta = 2),
    regexp = "There must be as much beta parameters than env_layers to be used to generate the resource layer."
  )

  expect_error(
    object = generate_resource_layer(env_layers = "toto", beta = 2),
    regexp = "env_layers must be of class SpatRast or data.frame"
  )
})
