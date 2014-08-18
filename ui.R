library(shiny)
library(plot3D)
library(scatterplot3d)
library(MASS)
library(kknn)
library(ROCR)


shinyUI(fixedPage(
    h2("'Guess-the-Torus' - simple nonlinear binary classification", 
       align = "center"),
    withMathJax(),
    h4("Synopsis"),
    p("'Guess-the-Torus' application demonstrates some of the basic 
      capabilities of the ", strong("Shiny"), " R package. The application 
      generates two data sets - a training data set and a testing data set. Each 
      data set has 4 columns and a user-specified number rows. The first three 
      columns (labeled 'x', 'y' and 'z') are the Cartesian coordinates of a 
      point in the 3D space and the last column (labeled 'outcome') has a value 
      of '0' or '1', depending on the point's position in space. All 3D points 
      that are inside of a torus centered in origin with R = 8 and r = 2 have 
      been labeled '1' and the 3D points outside the torus have been 
      labeled '0'."),
    fixedRow(
        column(5,
               br(),
               helpText("Torus equation: \\((R-\\sqrt{x^2+y^2})^2+z^2=r^2\\)"),
               helpText("\\(r = 2\\)        \\(R = 8\\)"),
               p("A torus has been chosen since it has a nonlinear shape and a 
                 non-convex volume. The prediction of the outcome is relatively 
                 simple, but non-trivial in the same time. The prediction model 
                 is being trained on the training set using the '", 
                 strong("Weighted k-Nearest Neighbors"), "' algorithm."),
               p("The chosen model has not been tuned and it doesn't perform 
                 very well since the prediction accuracy is not the objective of 
                 this application. In fact, even with proper tuning, other 
                 algorithms/models like '", strong("Random Forests"), "', '", 
                 strong("Boosting"), "' or '", strong("Multilayer perceptrons 
                 (ANN)"), "' could perform a lot better."),
               p("The ", strong("test data set"), " is used to generate the ", 
                 strong("ROC"), " curve for the model.")
        ),
        column(7,
            plotOutput(outputId = "torus_3d_plot"),
            br()
        )
    ),
    h4("Data sets"),
    p("The R function that generates the training and the testing data sets 
      takes one input parameter - ", strong("n"), " - the number of data points 
      on each of the Cartesian axes - ", strong("x"), ", ", strong("y"), 
      " and ", strong("z"), "."),
    fixedRow(
        column(4, 
               p("The total number of rows in each of the training and testing 
                 data sets will be \\(n^3\\). The default value of n is 12, so 
                 the initial number of rows in both data sets is 1728. The 
                 maximum value of n is 20 (8000 rows in the data set) such that 
                 the training of the KNN model will not take a very long time."),
               p("The slider below can be used to change the value of n. The 3D 
                 scatterplot besides the slider shows a sample (60%) of the 
                 generated training set."),
               br(),
               sliderInput('n', 'Number of points on each of the axes', 
                           value = 12, min = 10, max = 20, step = 2),
               br(),
               p("Rows in each of the data sets: ", textOutput("nrows", strong))
        ),
        column(8, plotOutput(outputId = "training_3d_scatterplot"))
    ),
    h4("KNN model performance"),
    fixedRow(
        column(4,
               p("To train the ", strong("K-Nearest Neighbors"), " model the ",
                 strong("kknn"), " function from the ", strong("kknn"), 
                 " R packge is used on the training data set."),
               p("After the model is trained, the performance is estimated 
                 from the predictions on 
                 the testing data set and the ", strong("ROC"), " curve is 
                 ploted using several functions from the ", strong("ROCR"), 
                 " R package."),
               p("As the data sets size (number of rows) changes, the accuracy 
                 of the KNN model changes. That change can be observed in the 
                 shape of the ", strong("ROC"), " curve. The data sets 
                 generation and the training of the model will take longer when 
                 n is large.")
        ),
        column(8, plotOutput(outputId = "model_ROC_curve", height = "350px"))
    ),
    h4("Prediction"),
    p("This section can be used to predict the position (outcome) - ", 
      strong("inside torus"), "or ", strong("outside torus"), " - of a 
      user-specified 3D point."),
    fixedRow(
        column(4,
               numericInput(inputId = 'x_val', 
                            label = strong('x - in interval [-12...12]:'), 
                            value = -12.00, min = -12.00, max = 12.00, 
                            step = 0.01)
        ),
        column(4,
               numericInput(inputId = 'y_val', 
                            label = strong('y - in interval [-12...12]:'), 
                            value = -12.00, min = -12.00, max = 12.00, 
                            step = 0.01)
        ),
        column(4,
               numericInput(inputId = 'z_val', 
                            label = strong('z - in interval [-5...5]:'), 
                            value = -5.00, min = -5.00, max = 5.00, step = 0.01)
        )
    ),
    p("KNN model prediction = ", textOutput("knn_prediction", strong), 
      " - True position = ", textOutput("true_position", strong)),
    br()
))
