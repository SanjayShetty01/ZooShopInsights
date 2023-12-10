box::use(shiny)
box::use(../../app/logic/calculateIncome)
box::use(../../app/logic/calculateCost)
box::use(../../app/logic/calculateYield)
box::use(../../app/logic/investmentRecoveryTime)

generateSliderInputs <- function(ns, prefix, numLevels, min, max, value) {
  lapply(1:numLevels, function(level) {
    shiny::sliderInput(ns(paste0(prefix, level)),
                paste('Enter the number of the Animal in Level', level),
                min = min, max = max, value = value)
  })
}

#' @export
incomeTabUI <- function(id){
  ns <- shiny::NS(id)

    sliderInputs <- generateSliderInputs(ns, "tab2-level", 20, 0 ,6, 0)
  shiny::flowLayout(
    shiny::h3(shiny::textOutput(ns('IncomeDay'))),
    shiny::h3(shiny::textOutput(ns('IncomeMonth'))),
    shiny::h3(shiny::textOutput(ns('IncomeYear'))),
    shiny::h3(shiny::textOutput(ns('Shopcost'))),
    shiny::h3(shiny::textOutput(ns('YieldFarm'))),
    shiny::h3(shiny::textOutput(ns('FarmReqDay'))),

    shiny::br(),
    shiny::br(),
    do.call(shiny::tagList, sliderInputs))
}


#' @export
incomeTabServer <- function(id){
  shiny::moduleServer(id, function(input, output, server){
    output$IncomeDay <- shiny::renderText({
      totalDailyIncome <- calculateIncome$calculateDailyIncome("tab2-level")

      paste0("The Total Expected Income for an hour is ",
             format(totalDailyIncome, big.mark = ',', trim = T), ' Coins')
    })

    output$IncomeMonth <- shiny::renderText({
      totalMonthIncome <- calculateIncome$calculateDailyIncome("tab2-level") * 30

      paste0("The Total Expected Income for a day is ",
             format(totalMonthIncome, big.mark = ',', trim = T), ' Coins')
    })

    output$IncomeYear <- shiny::renderText({
      totalYearlyIncome <- calculateIncome$calculateDailyIncome("tab2-level") |>
        (\(x) x * 30 * 365)()

      paste0("The Total Expected Income for a year is ",
             format(totalYearlyIncome, big.mark = ',', trim = T), ' Coins')
    })

    output$Shopcost <- shiny::renderText({
      shopCost <- calculateCost$calculateTotalShopCost("tab2-level")

      paste0("The Cost of the shop is ",
             format(shopCost, big.mark = ',', trim = T), ' Coins')
    })

    output$YieldFarm <- shiny::renderText({
      totalYield <- calculateYield$calculateTotalYield(
        inputName = "tab2-levels")

      paste0("The Yield of the farm for a year is ",
             format(yield, big.mark = ',', trim = T), '%')
    })

    output$FarmReqDay <- shiny::renderText({
      reqDay <- investmentRecoveryTime$investmentRecoveryTimeFarm(
        inputName = "tab2-levels")

      paste0("The Number of days to get back your Investments in the farm is ",
             format(reqDay, big.mark = ',', trim = T), 'days')
    })
  })
}
