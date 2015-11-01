library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(

  # Application title
  titlePanel("Chicago Crime Data for 2011"),

  # Sidebar with a slider input for the number of bins
  sidebarLayout(
    sidebarPanel(h3("Choose a Crime type"), position="left",
                 selectInput("type", "Type:", 
                choices = list("THEFT" ,"ASSAULT" ,"HOMICIDE","BURGLARY","DECEPTIVE PRACTICE",
                 "CRIMINAL TRESPASS","ROBBERY" , "BATTERY","NARCOTICS","SEX OFFENSE" ),
                selected = "HOMICIDE"),verbatimTextOutput("crimecount"),verbatimTextOutput("arrests")),
    # Show a plot of the generated distribution
    mainPanel(
      #plotOutput("map", width="600px",height="600px")
      tabsetPanel(type = "tabs", 
                  tabPanel("Map",plotOutput("map",width="600px",height="600px")),
                  tabPanel("Crime by Hour",plotOutput("histo")),
                  tabPanel("Crime By District",h3("Top Crime Districts"),dataTableOutput("district"))
      )
    )
  )
))
