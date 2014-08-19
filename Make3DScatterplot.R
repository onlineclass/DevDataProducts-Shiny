## This script contains only one function - plot.3D.data - which creates a 3D 
## scatter plot of the 3D data points in the provided data set. 
## The data set must contain a total of 4 columns: one column for each of 
## the cartesian coordinates x, y and z and one column for the class value 
## (outcome or label) of the 3D point. The outcome is always assumed to be the 
## last column of the data set. One color will be chosen for each value of the 
## outcome, except the one value to be ignored which must be specified at the 
## function call time. The function takes as input the following optional 
## parameters:
##      - data = the data set to be plotted
##      - density.plot = visibility of the density contour lines projected 
##        on xy, xz and yz planes
##      

plot.3D.data <- function(data, density.plot = T) {
    
    par(mar = c(1, 1, 1, 1))
    
    ## Get the outcome column index
    outcome.ndx = ncol(data)
    
    ## Create the subset of the original data which will be plotted
    plot.data <- data[data[,outcome.ndx] == "inside",]
    
    ## Define the background color
    bg.col <- c("#FF000088")
    
    ## Extract a sample of the raw data (4% of the data points) for the plot
    set.seed(1443)
    sample.plot.data <- plot.data[sample(1:nrow(plot.data), 
                                         as.integer(0.6 * nrow(plot.data)), 
                                         prob = rep(1 / nrow(plot.data), 
                                                    nrow(plot.data))),]
    
    x.intv <- c(min(data[,1]) - 5, max(data[,1]) + 5)
    y.intv <- c(min(data[,2]) - 5, max(data[,2]) + 5)
    z.intv <- c(min(data[,3]) - 5, max(data[,3]) + 5)
    
    s3d <- with(sample.plot.data, scatterplot3d(z ~ x + y, angle = 55, 
                                                scale.y = 0.75, type = "n", 
                                                pch = 21, bg = bg.col, 
                                                x.ticklabs = as.character(
                                                    c(-20, -15, -10, -5, 0, 5, 
                                                      10, 15, 20)), 
                                                grid = F, xlim = x.intv, 
                                                ylim = y.intv, zlim = z.intv))
    
    # Check if the density contour lines should be visible
    if (density.plot == T) {
        xyDensity <- kde2d(sample.plot.data$x, sample.plot.data$y, 
                           lims = c(x.intv, y.intv), n = 80)
        clines.xy <- contourLines(xyDensity, nlevels = 8)
        
        xzDensity <- kde2d(sample.plot.data$x, sample.plot.data$z, 
                           lims = c(x.intv, z.intv), n = 80)
        clines.xz <- contourLines(xzDensity, nlevels = 8)
        
        yzDensity <- kde2d(sample.plot.data$y, sample.plot.data$z, 
                           lims = c(y.intv, z.intv), n = 80)
        clines.yz <- contourLines(yzDensity, nlevels = 8)
        
        lapply(clines.xy, function(cl) {
            polygon(s3d$xyz.convert(cl$x, cl$y, rep(-10, length(cl$x))), 
                    lwd = 1, border = "#50505088")
        })
        
        lapply(clines.xz, function(cl) {
            polygon(s3d$xyz.convert(cl$x, rep(20, length(cl$x)), cl$y), 
                    lwd = 1, border = "#50505088")
        })
        
        lapply(clines.yz, function(cl) {
            polygon(s3d$xyz.convert(rep(-20, length(cl$x)), cl$x, cl$y), 
                    lwd = 1, border = "#50505088")
        })
    }
    
    # Now draw the actual points
    with(sample.plot.data, 
         s3d$points3d(z ~ x + y, pch = 21, col = "black", bg = bg.col))
}