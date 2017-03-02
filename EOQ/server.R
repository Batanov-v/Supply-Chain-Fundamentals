

library(shiny)
library(dplyr)
library(plotly)

shinyServer(function(input, output) {
   
  output$cost_plot <- renderPlotly({
    K <- input$order
    D <- input$demand
    H <- input$holding
    P <- input$purchasing
    
    Q <- sqrt(2*D*K/(H*P))
    Q <- round(Q)
    real_Q <- input$robust*Q
    EOQ_cost <- K*D/Q+H*P*Q/2+D*P
    real_cost <- K*D/real_Q+H*P*real_Q/2+D*P
    
    temp <- data.frame(quantity=seq(from=0,
                                    to=Q*5))
    temp <- temp %>%
      mutate (fixed=K*D/quantity,
              holding=H*P*quantity/2,
              unit=D*P,
              total=fixed+holding+unit
              )
    
    plot_ly(temp,
            x=~quantity,
            y=~total,
            name="Total cost",
            type = "scatter",
            mode="lines",
            line = list( width = 4)) %>%
      add_trace(y=~fixed,
                name = "Fixed order cost",
                line = list( width = 2,
                             dash = 'dash')) %>%
      add_trace(y=~holding,
                name = "Inventory-holding cost",
                line = list( width = 2,
                             dash = 'dash')) %>%
      add_trace(y=~unit,
                name = "Unit Cost",
                line = list( width = 2,
                             dash = 'dash')) %>%
      layout(title="Functions of the order quatity",
             xaxis = list(title = "Quantity"),
             yaxis = list (title = "Cost")) %>%
      add_annotations(x=list (Q,real_Q),
                      y=list (EOQ_cost,real_cost),
                      text=list("EOQ","real Q"),
                      xref = "x",
                      yref = "y",
                      showarrow = TRUE,
                      arrowhead = 7,
                      ax = 20,
                      ay = -40)
  })
  
  output$ex1 <- renderText({
    K <- input$order
    D <- input$demand
    H <- input$holding
    P <- input$purchasing
    
    Q <- sqrt(2*D*K/(H*P))
    Q <- round(Q)
    Int <- round (Q/D*365/7,2)
    real_Q <- input$robust*Q
    EOQ_cost <- K*D/Q+H*P*Q/2+D*P
    EOQ_cost <- round (EOQ_cost)
    real_cost <- K*D/real_Q+H*P*real_Q/2+D*P
    real_cost <- round (real_cost,2)
    
    str1 <- paste0("Optimal quantity: ",Q, ".")
    str2 <- paste0("Reoder interval: ",Int, " weeks.")
    str3 <- paste0("Total costs: ",EOQ_cost, "$.")
    str4 <- paste0("Currest costs: ",real_cost, "$.")
    str5 <- paste0("If ratio of quantity: ",
                   round (real_Q/Q*100),
                   "% then ratio of costs: ",
                   round (real_cost/EOQ_cost*100),
                   "%."
                   )
    
    paste(str1, str2, str3, str4, str5, sep = '<br/><br/>')
  })
  
})
