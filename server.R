library(shiny)
require(ggplot2)
require(dplyr)
library(data.table)
library(repmis)

#devtools::install_github('rstudio/rscrypt')
#addAuthorizedUser("lighthouse")



file <- 'sprayData.csv'
mykey <- 'qnvlxgrsvpr2zy1'

spraychart <- data.table(source_DropboxData(file,key=mykey, sep=",", header=TRUE))




shinyServer(
  function(input,output){
      
    output$batter.chart <- renderPlot({
      if(tolower(input$b.name) %in% tolower(spraychart$Hitter)){
      batterchart <- spraychart[tolower(Hitter)==tolower(input$b.name)]
      }else {batterchart <- spraychart[Hitter=='Mike Trout']}
      if(input$year!='All'){
      batterchart <- batterchart[year==input$year]
      }
      if(input$throws!="Both"){
        batterchart <- batterchart[Pitch.throws==input$throws]
      }
      if(input$outcome!='All'){
        batterchart <- batterchart[Description==input$outcome]
      }
      ggplot(data=batterchart,
             aes(x=x, y=-y,col=Description)) +
        geom_point()+
#         theme(axis.title.x=element_blank(),
#               axis.text.x=element_blank(),
#               axis.ticks.x=element_blank())+
#         theme(axis.title.y=element_blank(),
#               axis.text.y=element_blank(),
#               axis.ticks.y=element_blank()) +
        ggtitle(paste(batterchart$Hitter[1],'Spraychart'))
      
    })
    
    output$pitcher.chart <- renderPlot({
      if(tolower(input$p.name) %in% tolower(spraychart$Pitcher)){
        pitcherchart <- spraychart[tolower(Pitcher)==tolower(input$p.name)]
      }else {pitcherchart <- spraychart[Pitcher=='Chris Sale']}
      if(input$year!='All'){
        pitcherchart <- pitcherchart[year==input$year]
      }
      if(input$bats!="All"){
        pitcherchart <- pitcherchart[bats==input$bats]
      }
      if(input$outcome!='All'){
        pitcherchart <- pitcherchart[Description==input$outcome]
      }
      ggplot(data=pitcherchart,
             aes(x=x, y=-y,col=Description)) +
        geom_point()+
        #         theme(axis.title.x=element_blank(),
        #               axis.text.x=element_blank(),
        #               axis.ticks.x=element_blank())+
        #         theme(axis.title.y=element_blank(),
        #               axis.text.y=element_blank(),
        #               axis.ticks.y=element_blank()) +
        ggtitle(paste(pitcherchart$Pitcher[1],'Spraychart'))
    })
    

    
    
#     output$chart2 <- renderPlot({
#       
#                             
#       }else                               {plot <- ggplot(stolen.bases,aes(x=time,y=scoring.prob))+
#                                              geom_bar(aes(fill=time),stat='identity')+facet_grid(.~state) +
#                                              scale_size_continuous(guide="none") +
#                                              theme(legend.position='none') +
#                                              ggtitle  ("Probability of scoring at least one run before and after stolen base attempts") + 
#                                              xlab("situation and steal type (see explanations below)") + 
#                                              ylab("probability of scoring at least one run remainder of inning")}
#       
#       
#       return(plot)
      
      
    #})
    
    
    
    
    
    
    
    
})
