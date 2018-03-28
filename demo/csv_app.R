library(shiny)

source("../modules/csv_module.R")

ui <- navbarPage("ITHIM",
                 tabPanel("Introduction", 
                          sidebarLayout(
                            sidebarPanel(
                              csvFileUI("datafile_1", "Travel Survey Data (.csv format)"),
                              csvFileUI("datafile_2", "Health Survey Data (.csv format)")
                            ),
                            mainPanel(
                              fluidRow(dataTableOutput("table_1")),
                              fluidRow(dataTableOutput("table_2"))
                            )
                          )
                 ),
                 tabPanel("Component 1"),
                 tabPanel("Component 2"),
                 navbarMenu("More",
                            tabPanel("Component 1"),
                            tabPanel("Component 2")
                 ))

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