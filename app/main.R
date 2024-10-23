box::use(shiny, plotly, bs4Dash)
box::use(
  ./view/incomeModule,
  ./view/shopAnalysisModule,
  ./view/yieldModule,
  ./view/sidebarMenu,
  ./view/dashboardBody,
  ./view/dashBrand
)

#' @export
ui <- function(id) {
  ns <- shiny::NS(id)
  header <- bs4Dash::dashboardHeader(title = dashBrand$title)
  sidebar <- bs4Dash::dashboardSidebar(sidebarMenu$sidebarMenu,
                                       minified = F)

  body <- bs4Dash::dashboardBody(dashboardBody$mainBody(ns))

  bs4Dash::dashboardPage(
    header = header,
    sidebar = sidebar,
    body = body,
    fullscreen = T,
    help = NULL
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
