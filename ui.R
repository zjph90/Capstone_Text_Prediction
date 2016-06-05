require(markdown)

shinyUI(navbarPage("Next word prediction!", inverse=TRUE,
                   tabPanel("App",
                            sidebarLayout(
                                sidebarPanel(
                                    textInput("text", label = h3("Please enter some text: ")),
                                    submitButton("Submit"),
                                    hr(),   
                                    h4("Enter a phrase - eg:",style="padding: 10px 0px;"),                                   
                                    h5("Don't make me ...",style="padding: 5px 0px;margin-left: 20px"),
                                    h5("I like green eggs and ...",style="padding: 5px 0px;margin-left: 20px"),
                                    h5("We wish you a  ...",style="padding: 5px 0px;margin-left: 20px"),
                                    br()                                    
                                ),
                                mainPanel(
                                    br(),
                                    h2("Text entered:"),
                                    htmlOutput("text1"),
                                    br(),
                                    h2("Predicted next word: "),
                                    htmlOutput("text2"),
                                    htmlOutput("text3")
                                )
                            )
                   ),
                   tabPanel("Documentation",
                            includeMarkdown("documentation.md")
                   
                   )
))