library(shiny)
library(shinydashboard)

source("../modules/csv_module.R")

ui <- dashboardPage(title = "ITHIM",
  dashboardHeader(disable = T),
  dashboardSidebar(disable = T),
  dashboardBody(box(width=12,
                    tabBox(width=12,id="tabBox_next_previous",
                           tabPanel("Introduction",
                                    tabPanel("Component 1"),
                                    p(),
                                    actionLink("link_data_upload", "Data Upload")
                           ),
                           tabPanel("Data Uploads",
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
                           tabPanel("Results",
                                    dashboardSidebar())
  ))
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
  
  
  observeEvent(input$link_data_upload, {
    updateTabsetPanel(session, "tabBox_next_previous", "Data Uploads")
  })
  
}

shinyApp(ui, server)