# app.R
# A base dashboard to edit for your final project. See "Using the Dashboard Template."
# Based on "Hello Shiny!" https://shiny.posit.co/r/gallery/start-simple/faithful/

library(shiny)
library(tidyverse)


# The Data ---------------------------------------------------------------------------------------

# Save your cleaned data in app/data/, then delete the # below.
# Yes, you will have cleaned data in two places in your repo.

my_data <- read_csv("data/schools_merged.csv")


# The UI (what the reader sees) ------------------------------------------------------------------

ui <- fluidPage(
  
  titlePanel("your title"),
  p("For: who is making the decision"),
  p("The decision: the one decision this dashboard helps with"),
  
  selectInput(inputId = "pick", label = "Pick one:", choices = c("Grade 3", "Grade 4", "Grade 5")),
  
  h3("Figure 1. title"),
  plotOutput(outputId = "fig_1"),
  p("a sentence or two saying what the figure shows."),
  
  h3("Figure 2. title"),
  plotOutput(outputId = "fig_2"),
  p("a sentence or two saying what the figure shows."),
  
  h3("What this dashboard cannot tell you"),
  p("the limits of your data.")
  
)


# The Server (how the figures are made) ----------------------------------------------------------



server <- function(input, output) {
  
  output$fig_1 <- renderPlot({
    
    fig_data <- schools_long_math |>
      filter(grade_test == input$pick)
    
     ggplot(
      fig_data,
      aes(x = proficiency, y = school_name)) +
      geom_col() +
      labs(
        title = "Grade 3 ELA and Math Proficiency Across Evesham Schools",
        x = "Elementary School",
        y = "Proficiency (%)"
      )
     })
  
  output$fig_2 <- renderPlot({
    
    ggplot()     # replace with your code for Figure 2
    
  })
  
}


# Run the App ------------------------------------------------------------------------------------

shinyApp(ui = ui, server = server)
