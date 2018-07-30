library(ggsom)
library(kohonen)
library(tidyverse)
library(shinythemes)
library(ggthemes)

server <- function(input, output, session) {

    output$contents <- renderTable({
    # input$file1 will be NULL initially. After the user selects
    # and uploads a file, head of that data file by default,
    # or all rows if selected, will be shown.
    
    req(input$file1)
    
    # when reading semicolon separated files,
    # having a comma separator causes `read.csv` to error
    tryCatch({
      df <- read.csv(
        input$file1$datapath,
        header = input$header,
        sep = input$sep,
        quote = input$quote
      )
      
      updateCheckboxGroupInput(session,
                               "columns",
                               "Select Columns",
                               choices = names(df),
                               selected = names(df))
      
     
      
      output$table <- renderTable({
        df <- subset(df, select = input$columns) #subsetting takes place here
        
        model_som  <- kohonen::som(scale(df), grid=somgrid(6,4, "rectangular"))
        
        view_plot <- eventReactive (input$showPlot,  {
          switch(
            input$visualizations,
            "Line" = ggsom::ggsom_line(aes_som(model_som), input$change_color),
            "Ribbon" = ggsom::ggsom_ribbon(aes_som(
              model_som, cutree_value=input$slider_cluster_ribbon), TRUE),
            "Rect" = ggsom::ggsom_rect(
              aes_som(model_som, cutree_value=input$slider_cluster_rect),
              input$neurons_grid
            )
          )
          
        })
        
        output$plot <- renderPlot({
          view_plot()
          
        })
        
        head(df,10)
        
      })
      
    },
    error = function(e) {
      # return a safeError if a parsing error occurs
      stop(safeError(e))
    })
    
    if (input$disp == "head") {
      return(head(df))
    }
    else {
      return(df)
    }
    
  })
  
}
