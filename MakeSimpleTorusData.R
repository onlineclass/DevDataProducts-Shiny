## This script contains only one function - make.simple.torus.data - which 
## generates the training and testing data sets for the binary classification 
## on a non-convex volume. The generated data sets contains 4 columns: 
## 3 features/traits columns (one column for each of the cartesian 
## coordinates x, y and z) and 1 column for the outcome (a 2-level 
## factor - 0 or 1). The rows that have the value of the outcome = 1 are inside 
## a torus with user-specified parameters: torus 'r' and 'R'.
## All arguments of the 'make.simple.torus.data' function have default values  
## so a function call with no arguments - make.torus.data() - will still be  
## valid and will return the data sets.
## The function takes as input the following parameters:
##      - R = the large radius of the torus
##      - r = the small radius of the torus
##      - n = number of points on each axis in the data sets
## The function returns a list with the following elements:
##      - R = the large radius of the torus
##      - r = the small radius of the torus
##      - train.set = data frame with 3 features and 1 outcome
##      - test.set = data frame with the same structure as the 'train.set'
## Load the required 'plot3D' library (for 'mesh') and the multicore 
## parallelization library 'doMC'

make.simple.torus.data <- function(R = 8, r = 2, n = 10) {
    ## Defina the function to test if a point is inside the torus
    is.inside.torus <- function(x) 
        ifelse((R - sqrt(x[1] ^ 2 + x[2] ^ 2)) ^ 2 + x[3] ^ 2 < r ^ 2, 1, 0)

    ## Generate n points along each of the axis for the train.set
    x <- seq(-1.2 * (r + R), 1.2 * (r + R), length.out = n)
    xsd <- 2.4 * (r + R) / n / 4.5
    z <- seq(-2 * r, 2 * r, length.out = n)
    zsd <- 4 * r / n / 5.5
    set.seed(8443)
    x.train <- x + c(0, rnorm(n - 2, sd = xsd), 0)
    y.train <- x + c(0, rnorm(n - 2, sd = xsd), 0)
    z.train <- z + c(0, rnorm(n - 2, sd = zsd), 0)

    # Sort the data points
    x.train <- x.train[order(x.train)]
    y.train <- y.train[order(y.train)]
    z.train <- z.train[order(z.train)]

    ## Create the mesh for 3D volumes
    M.train <- mesh(x.train, y.train, z.train)

    ## Create the train data matrix from the mesh and compute the outcome column
    ## values (by checking if each 3-tuple (x, y and z) is inside the torus)
    train.mat <- as.matrix(cbind(as.vector(M.train$x), 
                                 as.vector(M.train$y), 
                                 as.vector(M.train$z)))
    train.inside.torus <- as.integer(apply(train.mat, 1, is.inside.torus))

    ## Create the final train data frame
    train.data <- data.frame(x = train.mat[,1], 
                             y = train.mat[,2], 
                             z = train.mat[,3], 
                             outcome = train.inside.torus)

    ## Generate n.test random points along each of the axis for the test.set
    set.seed(443)
    x.test <- x + c(0, rnorm(n - 2, sd = xsd), 0)
    y.test <- x + c(0, rnorm(n - 2, sd = xsd), 0)
    z.test <- z + c(0, rnorm(n - 2, sd = zsd), 0)

    # Sort the data points
    x.test <- x.test[order(x.test)]
    y.test <- y.test[order(y.test)]
    z.test <- z.test[order(z.test)]

    ## Create the mesh for 3D volumes
    M.test <- mesh(x.test, y.test, z.test)

    ## Create the test data matrix from the mesh and compute the outcome column
    ## values (by checking if each 3-tuple (x, y and z) is inside the torus)
    test.mat <- as.matrix(cbind(as.vector(M.test$x), 
                                as.vector(M.test$y), 
                                as.vector(M.test$z)))
    test.inside.torus <- as.integer(apply(test.mat, 1, is.inside.torus))

    ## Create the final test data frame
    test.data <- data.frame(x = test.mat[,1], 
                            y = test.mat[,2], 
                            z = test.mat[,3], 
                            outcome = test.inside.torus)

    ## Create and return the output list
    list(R = R, r = r, train.set = train.data, test.set = test.data)
}