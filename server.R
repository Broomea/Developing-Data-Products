library(shiny)
library(UsingR)
CO14ers <- read.csv("Data/Colorado_14ers.csv",stringsAsFactors=FALSE,header=TRUE)
library(plyr)
order <- (1:58)
ascendingCO14ers <- arrange(CO14ers,Elevation)
ascendingCO14ers$Order <- order

shinyServer(
  function(input, output) {
# This section creates the interactive plot of the mountains by height    
    output$newHeight <- renderPlot({
      par(oma = c(4, 2, 0, 0))  # This expands the bottom margin to allow room for the labels
      plot(ascendingCO14ers$Elevation,type="o",axes=FALSE,ylim=c(14000,14600),ylab=NA,xlab=NA)
      axis(1, at=1:58, labels=ascendingCO14ers$Peak,las=2)  # las= makes labels perpendicular to axis
      axis(2, at=seq(14000, 14500, by = 100), las=2)
      mtext(side = 1, cex=2.25,"Peak", line=8) # line= moves the position of the x label. Smaller # moves it up.
      mtext(side = 2, cex=2.25,"Elevation", line=4) # line= moves the position of the y label. Smaller # moves it right.
      abline(h = input$height, col="red",lwd = 2)
      peakSelected <- ascendingCO14ers[which(ascendingCO14ers$Elevation %in% input$height),]
      if (nrow(peakSelected) > 1) {
        abline(v = peakSelected[1,4], col="blue",lwd = 2)
        abline(v = peakSelected[2,4], col="blue",lwd = 2)
      } else {
        abline(v = peakSelected[4], col="blue",lwd = 2) 
      }
    })
# This section determines whether there is a mountain matching the height 
# selected and, if so, shows a picture of that mountain.
    output$newImage <- renderImage({
      peakSelected <- ascendingCO14ers[which(ascendingCO14ers$Elevation %in% input$height),]
      if (nrow(peakSelected) > 1) {
        fileName <- c(paste('www/','Peak', peakSelected[1,4], 'and', peakSelected[2,4], '.jpg', sep=''))
        list(src = fileName,
             width = 600,
             height = 200,
             alt = paste("Sorry - No peak matches this height: ", input$height, " ft."))
      } else {
        fileName <- c(paste('www/','Peak', peakSelected[4], '.jpg', sep='')) 
        list(src = fileName,
             width = 300,
             height = 200,
             alt = paste("Sorry - No peak matches this height: ", input$height, " ft."))
      }
    }, deleteFile = FALSE)
  }
)


