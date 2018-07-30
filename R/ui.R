shinyUI(fluidPage(
  theme = shinytheme("flatly"),
  navbarPage(
    title = "ggsom",
    id = "nav",
    ################### Tab Panel
    tabPanel(
      "Upload Files",
      value = "upload",
      sidebarLayout(
        # Sidebar panel for inputs ----
        sidebarPanel(
          # Input: Select a file ----
          fileInput(
            "file1",
            "Choose CSV File",
            multiple = FALSE,
            accept = c("text/csv",
                       "text/comma-separated-values,text/plain",
                       ".csv")
          ),
          
          # Horizontal line ----
          tags$hr(),
          
          # Input: Checkbox if file has header ----
          checkboxInput("header", "Header", TRUE),
          
          # Input: Select separator ----
          radioButtons(
            "sep",
            "Separator",
            choices = c(
              Comma = ",",
              Semicolon = ";",
              Tab = "\t"
            ),
            selected = ","
          ),
          
          # Input: Select quotes ----
          radioButtons(
            "quote",
            "Quote",
            choices = c(
              None = "",
              "Double Quote" = '"',
              "Single Quote" = "'"
            ),
            selected = '"'
          ),
          
          # Horizontal line ----
          tags$hr(),
          
          # Input: Select number of rows to display ----
          radioButtons(
            "disp",
            "Display",
            choices = c(Head = "head",
                        All = "all"),
            selected = "head"
          )
        ),
        
        # Main panel for displaying outputs ----
        mainPanel(# Output: Data file ----
                  tableOutput("contents"))
        
      )
      
    ),
    
    ################### Tab Panel
    tabPanel(
      "data",
      value = "data",
      
      checkboxGroupInput("columns", "Select Columns",
                         choices = NULL),
      
      
      mainPanel(tableOutput("table"))),
    
    ################### Tab Panel
    tabPanel(
      "Plots",
      value = "Plots",
      sidebarPanel(
        selectInput(
          "visualizations",
          "Choose a type of visualization:",
          choices = c("Line", "Ribbon", "Rect")
        ),
        
        #sliderInput("cluster", label = "Choose a numbers of cluster", value  = 3, min = 1, max = 5)
        conditionalPanel(
          condition = "input.visualizations == 'Line'",
          checkboxInput("change_color", strong("Show color"),
                        value = TRUE)
        ),
        conditionalPanel(
          condition = "input.visualizations == 'Ribbon'",
          sliderInput(
            "slider_cluster_ribbon",
            "Choose the numbers of cluster",
            min = 1,
            max = 4,
            value = 2,
            step = 1
          )
        ),
        conditionalPanel(
          condition = "input.visualizations == 'Rect'",
          sliderInput(
            "slider_cluster_rect",
            "Choose the numbers of cluster",
            min = 1,
            max = 4,
            value = 2,
            step = 1
          ),
          checkboxInput("neurons_grid", strong("Mark neurons per grid"),
                        value = TRUE)
        ),
        
        # Button
        actionButton("showPlot", "Plot")
        
      ),
      
      # Show a plot of the generated distribution
      mainPanel(plotOutput("plot"))
    
    )
  )
))
