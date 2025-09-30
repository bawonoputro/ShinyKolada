# app.R

if (!requireNamespace("Lab5", quietly = TRUE)) {
  if (!requireNamespace("remotes", quietly = TRUE)) install.packages("remotes")
  remotes::install_github("bawonoputro/Lab5")
}

library(shiny)
library(Lab5)

ui <- fluidPage(
  titlePanel("ShinyKolada"),
  tableOutput("mun")
)

server <- function(input, output, session) {
  output$mun <- renderTable(head(get_municipalities(), 6))
}

shinyApp(ui, server)
