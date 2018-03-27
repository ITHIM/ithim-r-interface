library(shiny)

source("../modules/csv_module.R")

ui <- fluidPage(
  sidebarLayout(
    sidebarPanel(
      csvFileUI("datafile_1", "User data (.csv format)"),
      csvFileUI("datafile_2", "User data (.csv format)")
    ),
    mainPanel(
      fluidRow(dataTableOutput("table_1")),
      fluidRow(dataTableOutput("table_2"))
    )
  )
)

server <- function(input, output, session) {
  datafile_1 <- callModule(csvFile, "datafile_1",
                         stringsAsFactors = FALSE)
  
  datafile_2 <- callModule(csvFile, "datafile_2",
                         stringsAsFactors = FALSE)
  
  output$table_1 <- renderDataTable({
    datafile_1()
  })
  
  output$table_2 <- renderDataTable({
    datafile_2()
  })
}

shinyApp(ui, server)