box::use(shiny, highcharter, bs4Dash)
box::use(../../app/logic/calculateIncome)
box::use(../../app/logic/calculateCost)
box::use(../../app/logic/calculateYield)
box::use(../../app/logic/investmentRecoveryTime)
box::use(../../app/logic/readFarmInfoData)

shopAnalysisUI <- function(id){
  ns <- shiny::NS(id)
  shiny::fluidPage(
    bs4Dash::box(
      title = "Portfolio Summary",
      status = "orange",
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
      status = "orange",
      icon = shiny::icon("chart-simple"),
      width = 12,

      highcharter::highchartOutput(ns("incomePlot")),
      highcharter::highchartOutput(ns("costPlot")),
      highcharter::highchartOutput(ns("reqDayPlot"))

  )
  )
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
        value = shiny::h2(scales::dollar(income)),
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
        value = shiny::h2(scales::dollar(income)),
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
        value = shiny::h2(scales::dollar(income)),
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
        value = shiny::h2(scales::dollar(shopCost)),
        icon = shiny::icon("money-bill"),
        color = "danger",
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
        icon = shiny::icon("percent"),
        color = "olive",
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
        subtitle = shiny::em(shiny::strong("Days Required to Recover")),
        value = shiny::h2(FarmReqDay),
        icon = shiny::icon("calendar-check"),
        color = "teal",
        width = 4
      )

    })

    output$reqDayPlot <- highcharter::renderHighchart({
      shiny::req(labelData())

      labelData_non_reactive <- labelData()

      highcharter::hchart(labelData_non_reactive,
                          "column",
                          highcharter::hcaes(x = Level, y = reqDays),
                          color = "#20c997",
                          name = "Days Required to Recover the Investment for each Level") |>
        highcharter::hc_title(text = "Days to Investment Recovery per Level") |>
        highcharter::hc_xAxis(title = list(text = "Level")) |>
        highcharter::hc_yAxis(title = list(text = "Days"))

    })

    output$incomePlot <- highcharter::renderHighchart({
      shiny::req(labelData())
      labelData_non_reactive <- labelData()

      highcharter::hchart(labelData_non_reactive,
                          "column",
                          highcharter::hcaes(x = Level, y = income),
                          color = "#28a745",
                          name = "Income from Animals for each Level") |>
        highcharter::hc_title(text = "Cost per Animal Level") |>
        highcharter::hc_xAxis(title = list(text = "Level")) |>
        highcharter::hc_yAxis(title = list(text = "Income (Hour)"))

    })

    output$costPlot <- highcharter::renderHighchart({
      shiny::req(labelData())
      labelData_non_reactive <- labelData()

      highcharter::hchart(labelData_non_reactive,
                          "column",
                          highcharter::hcaes(x = Level, y = cost),
                          color = "#dc3545",
                          name = "Cost of Animals for each Level") |>
        highcharter::hc_title(text = "Cost per Animal Level") |>
        highcharter::hc_xAxis(title = list(text = "Level")) |>
        highcharter::hc_yAxis(title = list(text = "Cost of Animal"))

    })

    }
  )
}

