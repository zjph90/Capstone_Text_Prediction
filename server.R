
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)

source("Predict_KN.R")



shinyServer(function(input, output) {

    prediction <-  reactive({
        if (input$text != "")
            names(Do_predict(input$text))[1:5]
        else 
            ""
    })
    

       
    output$text1 <- renderUI({ 
        h2(strong(input$text),style="color:darkblue;margin-left: 40px")
    })
    output$text2 <- renderUI({
        h1(strong(prediction()[1]),style="color:blue;margin-left: 40px;padding: 0px 0px")
    })
    output$text3 <- renderUI({
        h2(strong(HTML(paste(prediction()[-1], '<br/>'))),style="color:aqua;margin-left: 40px")
    })
})
