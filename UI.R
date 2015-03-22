shinyUI(fluidPage(
  titlePanel("What does a first name tell us about when you were born?"),
  
  sidebarLayout(
    sidebarPanel(
      tags$script(type="text/css", ".span8 .well { background-color: #00FFFF; }"),
      textInput("name", 
                  label = "Enter a first name and hit \"Submit\"",
                  value = "" ),
      
    #  selectInput("gender", label = h3("Select gender"), 
   #               choices = list("Choice 1" = M, "Choice 2" = F), 
    #              selected = 6),
      
      actionButton("submit", 
                  label = "Submit")
    ),
    
    mainPanel(
      tags$style(type="text/css",
                 ".shiny-output-error { visibility: hidden; }",
                 ".shiny-output-error:before { visibility: hidden; }"
      ),
      textOutput("error"),
      plotOutput("dist"),
      textOutput("plot_caption")
      
    )
  )
))