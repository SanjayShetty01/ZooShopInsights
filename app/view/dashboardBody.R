box::use(./incomeModule,
         ./shopAnalysisModule,
         ./yieldModule)

#' @export
mainBody <- function(ns) {
  bs4Dash::tabItems(
    bs4Dash::tabItem(
      tabName = 'profitablity_overveiw',
      shiny::br(),
      shiny::br(),
      yieldModule$yieldTabUI(ns("tab1"))
    ),
    bs4Dash::tabItem(
      "portfolio_setup",
      shiny::br(),
      shiny::br(),
      incomeModule$incomeTabUI(ns("tab2"))
    ),

    bs4Dash::tabItem(
      "dashboard",
      shiny::br(),
      shiny::br(),
      shopAnalysisModule$shopAnalysisUI(ns("tab3"))
    )
  )
}
