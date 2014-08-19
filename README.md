### Developing Data Products: Shiny Web Application

This repository contains the files of the '**Guess-The-Torus**' web application.   
The application has been created for the Developing Data Products course using 
the **Shiny** R package.
Following is a brief description of the files in this repository:
* **README.md** - this file
* **ui.R** - web application user interface (required by Shiny)
* **server.R** - server-side event handling R script (required by Shiny)
* **MakeSimpleTorusData.R** - contains the function used to generate 2 data sets - training.set and test.set
* **Make3DTorusSurfPlot.R** - contains the function used to plot a 3D surface using the **plot3D** R package
* **Make3DScatterPlot.R** - contains the function used to generate a 3D scatterplot of a sample from the training data set using the **scatterplot3d** R package
    
The application allows a user to specify the size of the data sets (both training and testing) and then to input 3D points (as a tuple of Cartesian coordinates x, y and z) and use the K-Nearest Neighbors model trained on the training set to predict whether the 3D point is inside a torus or not.

The web page contains a brief description of the application. For additional details, see the slidify description of the application. 
