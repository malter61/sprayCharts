library(shiny)


shinyUI(pageWithSidebar(
  
  headerPanel(h5("Baseball Spray Chart")),
  
    sidebarPanel(      
      br(),
      textInput("b.name","Batter name:",value="Mike Trout"),
      br(),
      textInput("p.name","Pitcher name:",value="Chris Sale"),
      br(),
      
      selectInput("year","Year:",c('All','2014','2015','2016'),selectize=F,multiple=F),          
      br(),

      selectInput("bats","Batter side (for pitcher charts):",c("All","Switch","R","L"),selectize=F,multiple=F),
      
      br(),

      selectInput("throws","Pitcher throws (for batter charts):",c("Both","R","L"),selectize=F,multiple=F),

      br(),
      selectInput('outcome','Outcome:',c('All','Groundout','Pop Out','Flyout',
                  'Lineout','Single','Double','Triple','Home Run'))
      
      
         
    ),
     
    mainPanel(
      tabsetPanel(type="tab",
          
                                   
                  tabPanel("Batter Spray Charts",HTML("<div> </div>"),
                           HTML
                           ("<div><br></br></div>"),

                           plotOutput("batter.chart"),
                           HTML
                           ("<div><br></br>
                            <b>Type any player in the 'Batter name' box at the top left.
                           and use the various filters to see the spraychart of your batter of interest.
                            </b><br></br></div>")),
                  
                  tabPanel("Pitcher Spray Charts",HTML("<div> </div>"),
                           plotOutput("pitcher.chart"),
                           HTML
                           ("<div><br></br>
                            <b>Type any player in the 'Pitcher name' box at the top left.
                           and use the various filters to see the spraychart of your pitcher of interest.
                            </b><br></br></div>"))

                  
                  
      )
    )
                
  ))


