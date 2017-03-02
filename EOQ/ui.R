  
library(shiny)
library(plotly)

shinyUI(navbarPage ("EOQ",
                    tabPanel("EOQ plot",
                             fluidPage(
                               sidebarLayout(
                                 sidebarPanel(
                                   numericInput(
                                     "demand",
                                     label = h3("Demand per year:"),
                                     value = 520
                                   ),
                                   numericInput(
                                     "order",
                                     label = h3("Fixed order cost:"),
                                     value = 10
                                   ),
                                   numericInput(
                                     "holding",
                                     label = h3("Annual inventory holding cost (%):"),
                                     value = 20
                                   ),
                                   numericInput(
                                     "purchasing",
                                     label = h3("Purchasing cost:"),
                                     value = 5
                                   ),
                                   sliderInput("robust",
                                               label = h3 ("Robustness of EOQ model"),
                                               min = 0.1,
                                               max = 5,
                                               value = 2
                                               )
                                 ),
                                 mainPanel(plotlyOutput ("cost_plot"
                                                         ),
                                           htmlOutput("ex1"
                                                    )
                                           )
                                 )
                               )
                             )
                    )
        )
