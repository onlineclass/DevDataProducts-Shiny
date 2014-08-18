## This script contains one function - plot.torus.surf - which plots the torus 
## surface (the torus used for generating the training and the test data sets).
## The function takes as input parameters:
##      - R = the large radius of the torus
##      - r = the small radius of the torus

plot.torus.surf <- function(R = 8, r = 2) {
    par(mar = c(1, 1, 1, 1))
    par(mfrow = c(1, 1))

    ## Create the data points in the x,y plane
    phi_seq <- seq(0, 2 * pi, length.out = 50)
    theta_seq <- seq(0, 2 * pi, length.out = 50)
    M <- mesh(phi_seq, theta_seq)

    phi <- M$x
    theta <- M$y

    ## Compute the (x,y,z) points of the torus surface on the mesh
    x <- (R + r * cos(phi)) * cos(theta)
    y <- (R + r * cos(phi)) * sin(theta)
    z <- r * sin(phi)

    ## Get the xt, yt and zt coordinate matrices
    xt <- matrix(as.vector(x), nrow = 50)
    yt <- matrix(as.vector(y), nrow = 50)
    zt <- matrix(as.vector(z), nrow = 50)

    x.interval <- c(min(xt) - 5, max(xt) + 5)
    y.interval <- c(min(yt) - 5, max(yt) + 5)
    z.interval <- c(min(zt) - 5, max(zt) + 5)

    ## Plot the torus
    surf3D(xt, yt, zt, col = "#FF080888", 
           lighting = list(ambient = 0.4, diffuse = 0.6, specular = 1., 
                           exponent = 20, sr = 0, alpha = 0.35), 
           ltheta = -180, lphi = -20, colkey = F, bty = "b2", scale = F, 
           zlim = z.interval, xlim = x.interval, ylim = y.interval, 
           ticktype = "detailed", cex.axis = 0.75)
}