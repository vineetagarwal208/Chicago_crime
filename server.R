library(shiny)
library(ggmap)
library(plyr)
load('chicagomap.RData')
mapPlot<-ggmap(map)

chicago1 <- read.csv("crimes.csv")

chicagoloc<-chicago1[((!is.null(chicago1$Latitude) & !is.null(chicago1$Longitude))&chicago1$Latitude>41.84 & chicago1$Latitude<42 & chicago1$Longitude>(-87.68) & chicago1$Longitude<(-87.55)),]

# Define server logic 
shinyServer(function(input, output) {

  output$map <- renderPlot({

    chicago<-chicagoloc[chicago1$Primary.Type==input$type,]
    
    hm<-ggmap(map) + geom_density2d(data = chicago, 
           aes(x = Longitude, y = Latitude), size = 0.2) + stat_density2d(data = chicago, 
           aes(x = Longitude, y = Latitude, fill = ..level.., alpha = ..level..), size = 0.05, 
           bins = 16, geom = "polygon") + scale_fill_gradient(low = "green", high = "red") + 
           scale_alpha(range = c(0, 0.5), guide = FALSE)
    print(hm)
    })
    
  output$histo<-renderPlot({   
    chicago<-chicago1[chicago1$Primary.Type==input$type ,]
    hist(chicago[,"hour"],breaks=24,main="Crime frequency by Hour", xlab="Hour of Day", ylab="Crime Count", col = 'darkgray', border = 'white',xaxt='n')
    axis(side=1, at=seq(0,24,6), labels=c("00:00","06:00","12:00","18:00","24:00"))
    })
    
  output$district <- renderDataTable({
    chicago<-chicago1[chicago1$Primary.Type==input$type,]
    table1=count(chicago$District)
    names(table1) = c("District", "Crime Count")
    (table1[with(table1, order(-table1[,2])),])[1:25,]
  })
  
  output$crimecount <-renderText({ 
    chicago<-chicago1[chicago1$Primary.Type==input$type,]
    paste("Number of Incidents",dim(chicago)[1])
    })
  
  output$arrests <-renderText({
    chicago<-chicago1[chicago1$Primary.Type==input$type,]
    paste("Number of Arrests",dim(chicago[chicago$Arrest=="TRUE",])[1])
  })
 
})
