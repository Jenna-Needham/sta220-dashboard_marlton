# app.R
# A base dashboard to edit for your final project. See "Using the Dashboard Template."
# Based on "Hello Shiny!" https://shiny.posit.co/r/gallery/start-simple/faithful/

library(shiny)
library(tidyverse)


# The Data ---------------------------------------------------------------------------------------

# Save your cleaned data in app/data/, then delete the # below.
# Yes, you will have cleaned data in two places in your repo.

schools_merged <- read_csv("data/schools_merged.csv")
growth_clean <- read_csv("data/growth_clean.csv")

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
  
  # Figure 1: Math proficiency
  
  output$fig_1 <- renderPlot({
    
    fig_data <- schools_long_math |>
      filter(grade_test == input$pick)
    
    ggplot(
      fig_data,
      aes(x = proficiency, y = school_name)
    ) +
      geom_col() +
      labs(
        title = paste(input$pick, "Math Proficiency Across Evesham Schools"),
        x = "Proficiency (%)",
        y = "Elementary School"
      )
    
  })
  
  
  # Figure 2: Student growth
  
  output$fig_2 <- renderPlot({
    
    ggplot(
      growth_long,
      aes(x = growth, y = school_name, fill = subject)
    ) +
      geom_col(position = "dodge") +
      labs(
        title = "Median Student Growth Across Evesham Schools",
        x = "Median Student Growth Percentile",
        y = "Elementary School",
        fill = "Subject"
      )
    
  })
  
}


# Run the App ------------------------------------------------------------------------------------

shinyApp(ui = ui, server = server)
