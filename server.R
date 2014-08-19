## This is the shiny server script
library(shiny)
library(plot3D)
library(scatterplot3d)
library(MASS)
library(kknn)
library(ROCR)
library(doMC)

registerDoMC(2)

source("Make3DTorusSurfPlot.R")
source("MakeSimpleTorusData.R")
source("Make3DScatterplot.R")

data.list <<- make.simple.torus.data()
R <<- 8
r <<- 2
train.data <<- data.list$train.set
test.data <<- data.list$test.set

shinyServer(
    function(input, output, session) {
        output$torus_3d_plot <- renderPlot({plot.torus.surf()})
        
        output$training_3d_scatterplot <- renderPlot({
            n_in <- input$n
            data.list <<- make.simple.torus.data(n = n_in)
            output$nrows <- renderText({paste("", n_in ^ 3)})
            
            plot.3D.data(data.list$train.set)
            
            kknnFit <- kknn(outcome ~ ., data.list$train.set, data.list$test.set)
            kknnPred <- prediction(kknnFit$prob[,2], data.list$test.set$outcome)
            kknnPerf <- performance(kknnPred, "tpr", "fpr")
            output$model_ROC_curve <- renderPlot({
                par(mar = c(5, 5, 2, 5))
                par(oma = c(4, 4, 2, 4))
                plot(kknnPerf, col = "orange", main = "kNN model ROC curve", 
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
                    kknnPred <- kknn(outcome ~ ., data.list$train.set, 
                                     data.frame(x = xv, y = yv, z = zv))
                    if (kknnPred$fitted.values == "inside") {
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