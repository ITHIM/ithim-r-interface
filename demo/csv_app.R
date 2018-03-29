library(shiny)
library(shinydashboard)

source("../modules/csv_module.R")

## Taken example from
# https://github.com/AntoineGuillot2/Shiny_NextPreviousArrow

Previous_Button <- tags$div(actionButton("Prev_Tab",HTML('<div class="col-sm-4"><i class="fa fa-angle-double-left fa-2x"></i></div>
                                                                  ')))
Next_Button <- div(actionButton("Next_Tab",HTML('<div class="col-sm-4"><i class="fa fa-angle-double-right fa-2x"></i></div>')))



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
                           tabPanel("Results"),
                           # navbarMenu("More",
                           #            tabPanel("Component 1"),
                           #            tabPanel("Component 2")
                           # ),
                           # tabPanel("tb4",p("This is tab 1")),
                           # tabPanel("tb5",p("This is tab 2")),
                           tags$script("
                                       $('body').mouseover(function() {
                                       list_tabs=[];
                                       $('#tabBox_next_previous li a').each(function(){
                                       list_tabs.push($(this).html())
                                       });
                                       Shiny.onInputChange('List_of_tab', list_tabs);})
                                       "
                           )
                    ),
                    uiOutput("Next_Previous")
  ))
)
# 
# ui <- navbarPage("ITHIM",
#                  tabsetPanel(id = "main_panel",
#                              tabPanel("Introduction",
#                                       tabPanel("Component 1"),
#                                       p(),
#                                       actionLink("link_data_upload", "Data Upload")
#                              ),
#                              tabPanel("Data Upload", 
#                                       sidebarLayout(
#                                         sidebarPanel(
#                                           csvFileUI("datafile_1", "Travel Survey Data (.csv format)"),
#                                           csvFileUI("datafile_2", "Health Survey Data (.csv format)")
#                                         ),
#                                         mainPanel(
#                                           fluidRow(dataTableOutput("table_1")),
#                                           fluidRow(dataTableOutput("table_2"))
#                                         )
#                                       )
#                              ),
#                              tabPanel("Component 2"),
#                              navbarMenu("More",
#                                         tabPanel("Component 1"),
#                                         tabPanel("Component 2")
#                              ))
# )

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
  
  output$Next_Previous=renderUI({
    tab_list <- input$List_of_tab[-length(input$List_of_tab)]
    nb_tab <- length(tab_list)
    if (which(tab_list == input$tabBox_next_previous) == nb_tab)
      column(1, offset=1, Previous_Button)
    else if (which(tab_list == input$tabBox_next_previous) == 1)
      column(1, offset = 10, Next_Button)
    else
      div(column(1, offset=1, Previous_Button), column(1, offset = 8, Next_Button))
    
  })
  
  observeEvent(input$Prev_Tab,
               {
                 tab_list <- input$List_of_tab
                 current_tab <- which(tab_list == input$tabBox_next_previous)
                 updateTabsetPanel(session, "tabBox_next_previous",selected = tab_list[current_tab - 1])
               }
  )
  observeEvent(input$Next_Tab,
               {
                 tab_list <- input$List_of_tab
                 current_tab <- which(tab_list == input$tabBox_next_previous)
                 updateTabsetPanel(session, "tabBox_next_previous", selected=tab_list[current_tab + 1])
               }
  )
  
}

shinyApp(ui, server)