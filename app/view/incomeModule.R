box::use(shiny)
box::use(shinyWidgets)
box::use(htmltools)
box::use(../../app/logic/calculateIncome)
box::use(../../app/logic/calculateCost)
box::use(../../app/logic/calculateYield)
box::use(../../app/logic/investmentRecoveryTime)
box::use(../../app/logic/readFarmInfoData)
box::use(./components/sliderInputs)

#' @export
incomeTabUI <- function(id){
  ns <- shiny::NS(id)
  sliderInputsUI <- sliderInputs$generateSliderInputs(
    ns, "tab2-level", 20, 0 ,6, 0)

  shiny::fluidPage(

    bs4Dash::box(
      title = "Enter Portfolio Details",
      status = "primary",
      icon = shiny::icon("pencil"),
      width = 12,

      shiny::fluidRow(class = "slider-row",
                      do.call(shiny::tagList, sliderInputsUI),
                      style = "justify-content: space-between;")
    ),

    shiny::fixedRow(
      shiny::column(
      width = 6,
      offset = 3,
      shinyWidgets::actionBttn(
        inputId = "submit-portfolio1",
        label = "Calculate Results",
        style = "material-flat",
        color = "primary"
      ) |>
        htmltools::tagAppendAttributes(style = "width: inherit;")
    ))
)
}


#' @export
incomeTabServer <- function(id){
  shiny::moduleServer(id, function(input, output, server){


    output$IncomeDay <- shiny::renderText({
      #totalDailyIncome <- calculateIncome$calculateDailyIncome("tab2-level")
      inputName <- "tab2-level"
      levels <- paste0(inputName, 1:20)
      data <- readFarmInfoData$readFarmInfoData()
      totalDailyIncome <- sapply(levels, \(x) input[[x]] *
                                   data$Expected_Income_Per_Hour[as.numeric(sub(inputName,
                                                                                '', x))]) |>
        sum() |>
        (\(x) x * 24)()
      round(2)

      paste0("The Total Expected Income for an hour is ",
             format(totalDailyIncome, big.mark = ',', trim = T), ' Coins')
    })

    output$IncomeMonth <- shiny::renderText({
      #totalMonthIncome <- calculateIncome$calculateDailyIncome("tab2-level") * 30
      inputName <- "tab2-level"
      levels <- paste0(inputName, 1:20)
      data <- readFarmInfoData$readFarmInfoData()
      totalDailyIncome <- sapply(levels, \(x) input[[x]] *
                                   data$Expected_Income_Per_Hour[as.numeric(sub(inputName,
                                                                                '', x))]) |>
        sum() |>
        (\(x) x * 24)()
      round(2)

      totalMonthIncome <- totalDailyIncome * 30
      paste0("The Total Expected Income for a day is ",
             format(totalMonthIncome, big.mark = ',', trim = T), ' Coins')
    })

    output$IncomeYear <- shiny::renderText({
      #totalYearlyIncome <- calculateIncome$calculateDailyIncome("tab2-level") |>
      #  (\(x) x * 30 * 365)()
      inputName <- "tab2-level"
      levels <- paste0(inputName, 1:20)
      data <- readFarmInfoData$readFarmInfoData()
      totalDailyIncome <- sapply(levels, \(x) input[[x]] *
                                   data$Expected_Income_Per_Hour[as.numeric(sub(inputName,
                                                                                '', x))]) |>
        sum() |>
        (\(x) x * 24)()
      round(2)

      totalYearlyIncome <- totalDailyIncome * 30 * 365

      paste0("The Total Expected Income for a year is ",
             format(totalYearlyIncome, big.mark = ',', trim = T), ' Coins')
    })

    output$Shopcost <- shiny::renderText({
      #shopCost <- calculateCost$calculateTotalShopCost("tab2-level")

      inputName <- "tab2-level"
      levels <- sapply(1:20, \(i) input[[paste0(inputName, i)]])
      prices <- readFarmInfoData$readFarmInfoData() |>
        (\(x) x$Price_in_Stores)()

      calculateShopCostPerLevel <- function(level, price){
        shopCost <- ifelse(levels == 0, 0, (levels * 300) + prices) |>
          sum() |>
          round(2)

        return(shopCost)
      }

      shopTotalCost <- calculateShopCostPerLevel(level = levels, price = prices)


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
