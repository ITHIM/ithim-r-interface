library(shiny)
library(readr)
library(ggplot2)

df <- read_csv("data/car_miles_per_person_per_week_london.csv")
df$label <- factor(df$label, levels = df$label)
df$col <- factor(df$label, levels = df$label)


ui <- fluidPage(
  fluidRow(
    column(width = 12,
           plotOutput("plot1",
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
           plotOutput("brush_info")
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
  })
}

shinyApp(ui, server)
