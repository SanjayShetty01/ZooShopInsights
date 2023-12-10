box::use(shiny, plotly)
box::use(
  ./view/incomeModule,
  ./view/shopAnalysisModule,
  ./view/yieldModule,
)


#' @export
ui <- function(id) {
  ns <- shiny::NS(id)
  shiny::fluidPage(
    shiny::tabsetPanel(shiny::tabPanel("Yield Calculator",
                                       shiny::br(),
                                       shiny::br(),
                       yieldModule$yieldTabUI(ns('tab1'))),

                       shiny::tabPanel("Income Calculator",
                                       shiny::br(),
                                       shiny::br(),
                                       incomeModule$incomeTabUI(ns("tab2"))),
                       shiny::tabPanel("Shop Analysis",
                                       shiny::br(),
                                       shiny::br(),
                       shopAnalysisModule$shopAnalysisUI(ns("tab3")))
                       ),
  )
}

#' @export
server <- function(id) {
  shiny::moduleServer(id, function(input, output, session) {
    yieldModule$yieldTabServer("tab1")

    incomeModule$incomeTabServer("tab2")

    shopAnalysisModule$shopAnalysisServer("tab3")
  })
}
