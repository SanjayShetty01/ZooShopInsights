box::use(./setupModule,
         ./dashboardModule,
         ./overviewModule)

#' @export
mainBody <- function(ns) {
  bs4Dash::tabItems(
    bs4Dash::tabItem(
      tabName = 'profitablity_overveiw',
      shiny::br(),
      shiny::br(),
      overviewModule$yieldTabUI(ns("tab1"))
    ),
    bs4Dash::tabItem(
      "portfolio_setup",
      shiny::br(),
      shiny::br(),
      setupModule$incomeTabUI(ns("tab2"))
    ),

    bs4Dash::tabItem(
      "dashboard",
      shiny::br(),
      shiny::br(),
      dashboardModule$shopAnalysisUI(ns("tab3"))
    )
  )
}
