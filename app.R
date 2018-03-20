library(shiny)
library(shinythemes)
library(readr)
library(ggplot2)
# library(Cairo)   # For nicer ggplot2 output when deployed on Linux

df <- read_csv("data/car_miles_per_person_per_week_london.csv")
df$label <- factor(df$label, levels = df$label)


ui <- fluidPage(
  fluidRow(
    column(width = 12,
           plotOutput("plot1", height = 300,
                      # Equivalent to: click = clickOpts(id = "plot_click")
                      click = "plot1_click",
                      brush = brushOpts(
                        id = "plot1_brush"
                      )
           )
    )
  ),
  fluidRow(width = 6,
           h4("Brushed points"),
           plotOutput("brush_info", height = 300,
                      # Equivalent to: click = clickOpts(id = "plot_click")
                      click = "plot1_click",
                      brush = brushOpts(
                        id = "plot1_brush"
                      )
           )
  )
)

server <- function(input, output) {
  output$plot1 <- renderPlot({
    ggplot(df, aes(x = label, y = val)) + geom_bar(stat="identity")
  })
  
  output$click_info <- renderPrint({
    # Because it's a ggplot2, we don't need to supply xvar or yvar; if this
    # were a base graphics plot, we'd need those.
    nearPoints(df, input$plot1_click, addDist = TRUE)
  })
  
  output$brush_info <- renderPlot({
    
    if (!is.null(input$plot1_brush) && !is.na(input$plot1_brush)){
      dat <- brushedPoints(df, input$plot1_brush)
      # browser()
      ggplot(dat, aes(x = label, y = val)) + geom_bar(stat="identity")
    }
    
    # brushedPoints(df, input$plot1_brush)
  })
}

shinyApp(ui, server)
