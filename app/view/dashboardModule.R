box::use(shiny, highcharter, bs4Dash)
box::use(../../app/logic/calculateIncome)
box::use(../../app/logic/calculateCost)
box::use(../../app/logic/calculateYield)
box::use(../../app/logic/investmentRecoveryTime)
box::use(../../app/logic/readFarmInfoData)

getAnimalShopSliderInputs <- function(start, end, max_value, ns) {
  lapply(start:end, function(i) {
    shiny::sliderInput(
      ns(paste0('shop', i)),
      paste('Enter the number of the Animal you have bought in Level', i),
      min = 0,
      max = max_value[i],
      value = 0
    )
  })
}


shopAnalysisUI <- function(id){
  ns <- shiny::NS(id)
  shiny::fluidPage(
    bs4Dash::box(
      title = "Portfolio Summary",
      status = "primary",
      icon = shiny::icon("box"),
      width = 12,

      shiny::fluidRow(
        bs4Dash::bs4InfoBoxOutput(ns("dailyIncome")),
        bs4Dash::bs4InfoBoxOutput(ns("monthlyIncome")),
        bs4Dash::bs4InfoBoxOutput(ns("yealyIncome"))
      ),

      shiny::fluidRow(
        bs4Dash::bs4InfoBoxOutput(ns("shopCost")),
        bs4Dash::bs4InfoBoxOutput(ns("farmYield")),
        bs4Dash::bs4InfoBoxOutput(ns("reqDays"))
      )
    ),

    bs4Dash::box(
      title = "Graphs",
      status = "primary",
      icon = shiny::icon("chart"),
      width = 12,

      highcharter::highchartOutput(ns("reqDayPlot")),
      highcharter::highchartOutput(ns("incomePlot")),
      highcharter::highchartOutput(ns("costPlot"))

  )
  )
  # animalShopSliderInputs <-  getAnimalShopSliderInputs(1, 20,
  #                                                     c(30, 25, 25, 25, 25, 25,
  #                                                       20, 20, 20, 15, 15, 15,
  #                                                       15, 15, 15, 10, 10, 10,
  #                                                       10, 10), ns)
  # shiny::flowLayout(do.call(shiny::tagList, animalShopSliderInputs))

}


shopAnalysisServer <- function(id, data) {
  shiny::moduleServer(id, function(input, output, session) {


    labelData <- shiny::reactive({
      shiny::req(data())

      labelData <- data()


      labelData$income <-  calculateIncome$calculateIncome(
        labelData$Level, labelData$NofAnimals)

      labelData$cost <- calculateCost$calculateShopCostPerLevel(
        labelData$NofAnimals)

      labelData$reqDays <- labelData$cost/ (labelData$income * 24)

      labelData

    })

    output$dailyIncome <- bs4Dash::renderbs4InfoBox({
      shiny::req(data())
      levelData <- data()

      income <- calculateIncome$calculateDailyIncome(
        level = levelData$Level,
        nAnimals = levelData$NofAnimals
      )


      bs4Dash::valueBox(
        subtitle = shiny::em(shiny::strong("Daily Income")),
        value = shiny::h2(income),
        icon = shiny::icon("money-bill"),
        color = "success",
        width = 4
      )

    })

    output$monthlyIncome <- bs4Dash::renderbs4InfoBox({
      shiny::req(data())
      levelData <- data()

      income <- calculateIncome$calculateMonthlyIncome(
        level = levelData$Level,
        nAnimals = levelData$NofAnimals
      )


      bs4Dash::valueBox(
        subtitle = shiny::em(shiny::strong("Monthly Income")),
        value = shiny::h2(income),
        icon = shiny::icon("money-bill"),
        color = "success",
        width = 4
      )

    })

    output$yealyIncome <- bs4Dash::renderbs4InfoBox({
      shiny::req(data())
      levelData <- data()

      income <- calculateIncome$calculateYearlyIncome(
        level = levelData$Level,
        nAnimals = levelData$NofAnimals
      )


      bs4Dash::valueBox(
        subtitle = shiny::em(shiny::strong("Yearly Income")),
        value = shiny::h2(income),
        icon = shiny::icon("money-bill"),
        color = "success",
        width = 4
      )

    })


    output$shopCost <- bs4Dash::renderbs4InfoBox({
      shiny::req(data())
      levelData <- data()

      shopCost <- calculateCost$calculateTotalShopCost(
        nAnimals = levelData$NofAnimals
      )


      bs4Dash::valueBox(
        subtitle = shiny::em(shiny::strong("Shop Cost")),
        value = shiny::h2(shopCost),
        icon = shiny::icon("money-bill"),
        color = "success",
        width = 4
      )

    })


    output$farmYield <- bs4Dash::renderbs4InfoBox({
      shiny::req(data())
      levelData <- data()

      totalYield <- calculateYield$calculateTotalYield(levelData$Level,
                                                     levelData$NofAnimals)


      bs4Dash::valueBox(
        subtitle = shiny::em(shiny::strong("Farm Yield")),
        value = shiny::h2(totalYield),
        icon = shiny::icon("money-bill"),
        color = "success",
        width = 4
      )

    })


    output$reqDays <- bs4Dash::renderbs4InfoBox({
      shiny::req(data())
      levelData <- data()

      FarmReqDay <-   investmentRecoveryTime$investmentRecoveryTimeFarm(
        levelData$Level,
        levelData$NofAnimals)


      bs4Dash::valueBox(
        subtitle = shiny::em(shiny::strong("plceholder")),
        value = shiny::h2(FarmReqDay),
        icon = shiny::icon("money-bill"),
        color = "success",
        width = 4
      )

    })

    output$reqDayPlot <- highcharter::renderHighchart({
      shiny::req(labelData())

      labelData_non_reactive <- labelData()

      highcharter::hchart(labelData_non_reactive,
                          "column",
                          highcharter::hcaes(x = Level, y = reqDays),
                          color = "#0198f9",
                          name = "Days Required to Recover the Investment for each Level") |>
        highcharter::hc_title(text = "Required Days", align = "left") |>
        highcharter::hc_xAxis(title = list(text = "Level")) |>
        highcharter::hc_yAxis(title = list(text = "Required Days to Recover the Investment"))

    })

    output$incomePlot <- highcharter::renderHighchart({
      shiny::req(labelData())
      labelData_non_reactive <- labelData()

      highcharter::hchart(labelData_non_reactive,
                          "column",
                          highcharter::hcaes(x = Level, y = income),
                          color = "#0198f9",
                          name = "Income from Animals for each Level") |>
        highcharter::hc_title(text = "Income", align = "left") |>
        highcharter::hc_xAxis(title = list(text = "Level")) |>
        highcharter::hc_yAxis(title = list(text = "Income/ Hour"))

    })

    output$costPlot <- highcharter::renderHighchart({
      shiny::req(labelData())
      labelData_non_reactive <- labelData()

      highcharter::hchart(labelData_non_reactive,
                          "column",
                          highcharter::hcaes(x = Level, y = cost),
                          color = "#0198f9",
                          name = "Cost of Animals for each Level") |>
        highcharter::hc_title(text = "Cost of Animal per Level", align = "left") |>
        highcharter::hc_xAxis(title = list(text = "Level")) |>
        highcharter::hc_yAxis(title = list(text = "Cost of Animal"))

    })

    }
  )
}

