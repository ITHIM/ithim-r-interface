csvFileUI <- function(id, label = "CSV file") {
  # Create a namespace function using the provided id
  ns <- NS(id)
  
  tagList(
    fileInput(ns("file"), label,
              accept = c(
                "text/csv",
                "text/comma-separated-values,text/plain",
                ".csv")),
    checkboxInput(ns("heading"), label = "Has heading", value = T)#,
    # selectInput(ns("quote"), "Quote", c(
    #   "None" = "",
    #   "Double quote" = "\"",
    #   "Single quote" = "'"
    # ))
  )
}

# Module server function
csvFile <- function(input, output, session, stringsAsFactors) {
  # The selected file, if any
  userFile <- reactive({
    # If no file is selected, don't do anything
    #validate(need(input$file, message = FALSE))
    
    validate(
      # If no file is selected, don't do anything
      need(input$file, message = FALSE),
      # If not csv, display the warning message
      need(tools::file_ext(input$file) != "csv", "Please select a csv file")
    )
    
    input$file
  })
  
  
  
  # The user's data, parsed into a data frame
  dataframe <- reactive({
    
    if (!is.null(userFile()) && tools::file_ext(userFile()) == "csv"){
      read.csv(userFile()$datapath,
               header = input$heading,
               quote = input$quote,
               stringsAsFactors = stringsAsFactors)
    }
  })
  
  # We can run observers in here if we want to
  observe({
    msg <- sprintf("File %s was uploaded", userFile()$name)
    cat(msg, "\n")
  })
  
  # Return the reactive that yields the data frame
  return(dataframe)
}