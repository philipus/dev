library(shiny)
shinyUI(
  pageWithSidebar(
    # Application title
    headerPanel("Building a Model using Binning + logistic Regression depending on the p-value as an input of the smbinning packet \n
                you just need to put an reasonyble p value like in logistic regression and press submit. \n
                it will try to make optimal binning for all the variables V1-V60 of the Sonar data in the mlbench package \n
                a model will be trained with the binned variables and the accuracy will be calculated by the \n
                ConfusionMatrix of testing data"),
    sidebarPanel(
      numericInput('pValue', 'P Value for Binning', 0.2, min = 0.01, max = 0.5),
      submitButton('Submit')
    ),
    mainPanel(
      h3('Accuracy of the Modell'),
      h4('You entered a P Value of'),
      verbatimTextOutput("pValue"),
      h4('Which resulted in a accuracy of the model'),
      verbatimTextOutput("accuracy"),
      h4('binned Variables'),
      verbatimTextOutput("binned")
    )
  )
)