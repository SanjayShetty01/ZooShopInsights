generateSliderInputs <- function(ns, prefix, start, end, max_value) {
  lapply(start:end, function(level) {
    shiny::sliderInput(
      ns(paste0(prefix, level)),
      paste('Enter the number of the Animal you have bought in Level', level),
      min = 0,
      max = max_value[level],
      value = 0,
      width = "250px"
    )
  })
}
