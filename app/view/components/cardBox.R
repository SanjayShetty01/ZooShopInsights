if (interactive()) {
  library(shiny)
  library(bs4Dash)

  shinyApp(
    ui = dashboardPage(
      header = dashboardHeader(),
      sidebar = dashboardSidebar(
        sidebarMenu(
          menuItem(
            text = "Item 1",
            tabName = "tab1"
          ),
          menuItem(
            text = "Item 2",
            tabName = "tab2"
          )
        )
      ),
      controlbar = dashboardControlbar(),
      footer = dashboardFooter(),
      title = dashboardHeader("hi"),
      body = dashboardBody(
        tabItems(
          tabItem(
            tabName = "tab1",
            fluidRow(
              infoBox(
                title = "Messages",
                value = 1410,
                icon = icon("envelope"),
                color = "orange",
                fill = TRUE,
              ),
              infoBox(
                title = "Bookmarks",
                color = "info",
                value = 240,
                icon = icon("bookmark"),
                tabName = "tab2"
              )
            )
          ),
          tabItem(
            tabName = "tab2",
            infoBox(
              title = "Comments",
              color = "indigo",
              gradient = TRUE,
              value = 41410,
              subtitle = "A subtitle",
              icon = icon("comments"),
              tabName = "tab1",
              fill = T
            )
          )
        )
      )
    ),
    server = function(input, output) {}
  )
}
