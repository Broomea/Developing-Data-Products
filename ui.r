library(shiny)

shinyUI(pageWithSidebar(
  headerPanel("Colorado Peaks Over 14,000 Ft."),
  sidebarPanel(
    sliderInput('height', 'How High Will You Climb?',value = 14009, min = 14000, max = 14440, step = 1,)
  ),
  mainPanel(
    plotOutput('newHeight'),
    imageOutput('newImage')
  )
))