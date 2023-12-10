box::use(./readFarmInfoData)

#' Calculate the income for a specific animal type and quantity.
#'
#' This function takes the level of an animal type and the quantity of that
#' animal and calculates the income based on the expected income per hour for
#' that animal type.
#'
#' @param level The level of the animal type.
#' @param nAnimal The quantity of the animal.
#' @return The calculated income for the specified animal type and quantity.
#'
#' @examples
#' # Example usage:
#' # calculateIncome(level = 1, nAnimal = 5)
#'
#' @export
calculateIncome <- function(level, nAnimal){
  income <- readFarmInfoData$readFarmInfoData() |>
    (\(x) x$Expected_Income_Per_Hour[level])() |>
    (\(x) x * nAnimal )()

  return(income)
}


#' Calculate the total daily income for all animal types.
#'
#' This function takes the input names representing different levels of animal
#' types and calculates the total daily income based on the quantities and
#' expected income per hour for each animal type.
#'
#' @param inputName The prefix of the input names representing different levels.
#' @return The total daily income for all animal types.
#'
#' @examples
#' # Example usage:
#' # calculateDailyIncome("level")
#'
#' @export


calculateDailyIncome <- function(inputName){
    levels <- paste0(inputName, 1:20)
    data <- readFarmInfoData$readFarmInfoData()
    totalIncome <- sapply(levels, \(x) inputName[[x]] *
                       data$Expected_Income_Per_Hour[as.numeric(sub(inputName,
                                                                  '', x))]) |>
      sum() |>
      (\(x) x * 24)()
      round(2)
    return(totalIncome)
}

