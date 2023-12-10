#' Read Farm Information Data
#'
#' This function reads farm information data from an RDS file.
#'
#' @return A data frame containing farm information.
#' @export
#'
#' @examples
#' \dontrun{
#'   data <- readFarmInfoData()
#' }
#'

readFarmInfoData <- function(){
  data <- base::readRDS("./app/logic/data/data.rds")
  return(data)
}
