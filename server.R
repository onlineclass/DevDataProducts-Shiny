## This is the shiny server script
library(shiny)
library(plot3D)
library(scatterplot3d)
library(MASS)
library(kknn)
library(ROCR)

source("Make3DTorusSurfPlot.R")
source("MakeSimpleTorusData.R")
source("Make3DScatterplot.R")

data.list <<- make.simple.torus.data()
R <<- 8
r <<- 2
train.data <<- data.list$train.set
test.data <<- data.list$test.set
train.data$outcome <- as.factor(ifelse(train.data$outcome > 0, "success", 
                                       "failure"))
test.data$outcome <- as.factor(ifelse(test.data$outcome > 0, "success", 
                                      "failure"))

shinyServer(
    function(input, output, session) {
        output$torus_3d_plot <- renderPlot({plot.torus.surf()})
        
        output$training_3d_scatterplot <- renderPlot({
            n_in <- input$n
            data.list <<- make.simple.torus.data(n = n_in)
            output$nrows <- renderText({paste("", n_in ^ 3)})
            
            plot.3D.data(data.list$train.set)
            
             train.data <<- data.list$train.set
             test.data <<- data.list$test.set
             train.data$outcome <- as.factor(ifelse(train.data$outcome > 0, 
                                                "success", "failure"))
             test.data$outcome <- as.factor(ifelse(test.data$outcome > 0, 
                                               "success", "failure"))
             
             kknnFit <- kknn(outcome ~ ., train.data, test.data)
             kknnPred <- prediction(kknnFit$prob[,2], test.data$outcome)
             kknnPerf <- performance(kknnPred, "tpr", "fpr")
             output$model_ROC_curve <- renderPlot({
                 par(mar = c(5, 5, 5, 5))
                 plot(kknnPerf, col = "orange", main = "KNN model ROC curve", 
                      xlab = "False Pos. Rate", ylab = "True Pos. Rate", 
                      lwd = 3)})
             updateNumericInput(session, "x_val", value = -12)
             updateNumericInput(session, "y_val", value = -12)
             updateNumericInput(session, "z_val", value = -5)
        })
        
        output$true_position <- renderText({
            xv <- input$x_val
            yv <- input$y_val
            zv <- input$z_val
             
            if (!is.na(xv) && !is.na(yv) && !is.na(zv) && xv >= -12 && 
                  xv <= 12 && yv >= -12 && yv <= 12 && zv >= -5 && zv <= 5) {
                output$knn_prediction <- renderText({
                    kknnPred <- kknn(outcome ~ ., train.data, 
                                     data.frame(x = xv, y = yv, z = zv))
                    if (kknnPred$fitted.values > 0.5) {
                        paste("inside torus")
                    } else {
                        paste("outside torus")
                    }
                })
                if ((R - sqrt(xv ^ 2 + yv ^ 2)) ^ 2 + zv ^ 2 <= r ^ 2) {
                    paste("inside torus")
                } else {
                    paste("outside torus")
                }
            } else {
                output$knn_prediction <- renderText({
                    paste("_____________")
                })
                paste("_____________")
            }
        })
    }
)