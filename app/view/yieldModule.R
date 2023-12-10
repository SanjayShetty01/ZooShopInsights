box::use(shiny)
box::use(../../app/logic/calculateIncome)
box::use(../../app/logic/calculateYield)
box::use(../../app/logic/investmentRecoveryTime)
box::use(../../app/logic/calculateCost)


#' @export
yieldTabUI <- function(id){
  ns <- shiny::NS(id)

  shiny::sidebarLayout(
    shiny::sidebarPanel(
      shiny::fixedRow(
        shiny::selectInput(ns('storeType'), 'Store or Daily Store?',
                    c("Evo Store" = 'Price_in_Stores',
                      'Daily Shop' = 'DailyPrice'))),
      shiny::fixedRow(
        shiny::numericInput(ns('Nbought'), "Enter the number of animals already
                            bought in the shop", 0),
        style = "margin-bottom:-15px;"),
      shiny::tags$small(shiny::em('*Only applicable for Evolution Store')),
      shiny::br(),
      shiny::br(),
      shiny::fixedRow(
        shiny::sliderInput(ns('Nanimal'), 'Number of Animals', min = 1, max = 10, value = 1),
        shiny::sliderInput(ns('Level'), 'Enter the Level of the Animal', min = 1, max = 20, value = 2)),
    ),
    shiny::mainPanel(
      shiny::h3(shiny::textOutput(ns('cost'))),
      shiny::h3(shiny::textOutput(ns('yield'))),
      shiny::h3(shiny::textOutput(ns('reqDays')))))
}

#' @export
yieldTabServer <- function(id){
  shiny::moduleServer(id, function(input, output, server){
    output$cost <- shiny::renderText({
      cost <- calculateCost$calculateCost(level = input$Level,
                                          nAnimal = input$Nanimal,
                                          store_type = input$storeType,
                                          nAnimalBought = input$Nbought)

      paste0("The Price of animals of would be ",
             format(cost, big.mark = ',', trim = T))
    })

    output$yield <- shiny::renderText({
      yield <- calculateYield$calculateYield(level = input$Level,
                                             nAnimal = input$Nanimal,
                                             store_type = input$storeType,
                                             nAnimalBought = input$Nbought)

      paste0("The Yield of the animal for a year is ", yield, '%')
    })

    output$reqDays <- shiny::renderText({
      reqDays <- investmentRecoveryTime$investmentRecoveryTime(
        level = input$Level, nAnimal = input$Nanimal,
        store_type = input$storeType, nAnimalBought = input$Nbought)

      paste0("Days required to get back the investment ", reqDays, ' Days')
    })
  })
}
