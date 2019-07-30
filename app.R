#Shiny Dashboard

library(shinydashboard)
library(mapproj)
library(maps)

counties <- readRDS("data/counties.rds")
source("helpers.R")
#UI

titledata <- tags$label(tags$img(src = "dummydataimg.png", height = '60', width = '60'), 
                  tags$b("Company Name"))

ui <- dashboardPage(
  dashboardHeader(title = titledata,
                  # Set height of dashboardHeader
                  tags$li(class = "dropdown",
                          tags$style(".main-header {max-height: 60px}"),
                          tags$style(".main-header .logo {height: 60px; padding-left:0px;text-align:left;}"),
                         
                          tags$style(".sidebar-toggle {height: 60px; padding-top: 16px !important;}"),
                          tags$style(".navbar {min-height:60px !important}")
                    
                  ) ),
  dashboardSidebar(
    # Adjust the sidebar
    sidebarMenu(
      
      menuItem("Dashboard", tabName = "dashboard", icon = icon("dashboard")),
      menuItem("Instructions", tabName = "instruct", icon = icon("file-text-o"))
    ),
    
    
    tags$style(".left-side, .main-sidebar {padding-top: 60px}")
  ),
  
  dashboardBody(
    # Boxes need to be put in a row (or column)
    tabItems(
      
    tabItem(tabName = "dashboard",
    fluidRow(
      box(  width =12,height =450 ,title = "Map", solidHeader = TRUE, status = "info",
        plotOutput("plot1",height = 390))),
    fluidRow(  
      box( width = 12,
        title = "Inputs", background = "black", collapsible = TRUE, collapsed = TRUE,
        selectInput("var",
                    label = "Choose a variable to display",
                    choices = c("Percent White", "Percent Black", "Percent Asian", "Percent Hispanic"),
                    selected = "Percent White"),
        sliderInput("slider", "Number of observations:", min = 1,max = 100,value = c(1,100)))
    )),
    
    tabItem(tabName = "instruct",
            h2("Instructions")
      )
    
    
    )
  
  )
)

server <- function(input, output) {
  #set.seed(122)
  
  
  output$plot1 <- renderPlot({
    
    data <- switch(input$var, 
                   "Percent White" = counties$white,
                   "Percent Black" = counties$black,
                   "Percent Hispanic" = counties$hispanic,
                   "Percent Asian" = counties$asian)
    
    color <- switch(input$var, 
                    "Percent White" = "darkgreen",
                    "Percent Black" = "black",
                    "Percent Hispanic" = "darkorange",
                    "Percent Asian" = "darkviolet")
    
    legend <- switch(input$var, 
                     "Percent White" = "% White",
                     "Percent Black" = "% Black",
                     "Percent Hispanic" = "% Hispanic",
                     "Percent Asian" = "% Asian")
    
    percent_map(data, color, legend, input$slider[1], input$slider[2])
  })
}

shinyApp(ui, server)