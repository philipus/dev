library(shiny)

library(mlbench)
data(Sonar)
Sonar$y <- ifelse(as.numeric(Sonar$Class) == 2, 1, 0)
#
library(caret)
set.seed(998)
inTraining <- createDataPartition(Sonar$Class, p = .75, list = FALSE)
training <- Sonar[ inTraining,]
testing  <- Sonar[-inTraining,]
#
library(smbinning)
#
accuracy <- function( aPValue ){
  res <- lapply(names(training)[1:60],function(var) { smbinning(df=Sonar,y="y",x=var,p = aPValue) } )
  binned <- ifelse(as.vector(lapply(res,length)) == 1, 0, 1)
  binned_vars <- names(training[1:60])[binned == 1]
  training_c <- cbind(as.data.frame(lapply(which(binned==1), function(var) { 
    smbinning.gen(training,res[[var]],paste("c_V",var,sep=""))[paste("c_V",var,sep="")]
  })), Class=training$Class)
  #
  set.seed(825)
  glmFit <- train(Class ~ ., data = training_c,
                  method = "LogitBoost",
                  family    = binomial ,
                  #trControl = fitControl,
                  ## This last option is actually one
                  ## for gbm() that passes through
                  verbose = FALSE)
  glmFit
  #
  testing_c <- cbind(as.data.frame(lapply(which(binned==1), function(var) { 
    smbinning.gen(testing,res[[var]],paste("c_V",var,sep=""))[paste("c_V",var,sep="")]
  })), Class=testing$Class)
  #
  list(confusionMatrix(predict(glmFit,testing_c), testing_c$Class)$overall[1],binned, binned_vars, res)
}


shinyServer(
  function(input, output) {
    output$pValue <- renderPrint({input$pValue})
    output$accuracy <- renderPrint({
                                    accuracy(input$pValue)[[1]]
                                    })
    output$binned <- renderPrint({
                                    accuracy(input$pValue)[[3]]
                                    })
  }
)
