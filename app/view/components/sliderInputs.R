generateSliderInputs <- function(ns, prefix, numLevels, min, max, value) {
  lapply(1:numLevels, function(level) {
    #use flowchart here
    shiny::sliderInput(ns(paste0(prefix, level)),
                       paste('Enter the number of the Animal in Level', level),
                       min = min, max = max, value = value)
  })
}
