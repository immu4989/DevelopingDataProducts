library(shiny)

langs <- c("italian")

shinyUI(fluidPage(
  includeMarkdown("README.md"),
  headerPanel("Headline News - Categorization"),
  sidebarPanel(
    
    textInput("headline", "Headline - Please, insert a headline in Italian", 
              value = "Moscovici: Piu flessibilita allItalia ma fate gli sforzi per le riforme"),
    
    selectInput("lang", "Select the language:", choices = langs,
                selected = "italian"),
    
    submitButton("Go")
  ),
  
  mainPanel(
    
    h3("Headline Categorization"),
    h4("The entered headline is:"),
    verbatimTextOutput("headline"),
    h4("And your content is: "),
    verbatimTextOutput("categorization")

  )
  
))
