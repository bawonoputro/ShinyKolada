if (!requireNamespace("Lab5", quietly = TRUE)) {
  if (!requireNamespace("remotes", quietly = TRUE)) install.packages("remotes")
  remotes::install_github("bawonoputro/Lab5")
}

if (!requireNamespace("DT", quietly = TRUE)) {
  stop("The Shiny app requires the 'DT' package. Please install it with install.packages('DT').")
}

library(shiny)
library(Lab5)
library(DT)

ui <- fluidPage(
  titlePanel("ShinyKolada"),
  h4("Municipalities"),
  DTOutput("mun"),
  tags$hr(),
  h4("KPIs"),
  DTOutput("kpi"),
  tags$hr(),
  h4("Organisation Units"),
  selectInput("ou_filter", "Filter by municipality:",
              choices = c("All" = "All"), selected = "All"),
  DTOutput("ou")
)

server <- function(input, output, session) {

  #Municipalities
  output$mun <- renderDT({
    get_municipalities()
  }, options = list(pageLength = 15))

  #KPIs
  output$kpi <- renderDT({
    k <- get_kpi()
    keep <- intersect(c("id", "title", "publication_date", "description", "updated"), names(k))
    if (length(keep) == 0) return(k)
    k[, keep, drop = FALSE]
  }, options = list(pageLength = 20))


  # OUs
  all_ou <- get_ou()
  mun_df <- get_municipalities()



  observe({
    mun_choices <- unique(all_ou$municipality)
    mun_choices <- mun_choices[!is.na(mun_choices)]
    updateSelectInput(session, "ou_filter",
                      choices = c("All", mun_choices),
                      selected = "All")
  })


  output$ou <- renderDT({
    o <- all_ou
    if (input$ou_filter != "All") {
      o <- subset(o, municipality == input$ou_filter)
    }
    o <- o[c("id", "title", "municipality")]
    datatable(o, options = list(pageLength = 20))
  })
}

shinyApp(ui, server)
