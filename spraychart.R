library(ggvis)
library(pitchRx)
library(dplyr)
library(plyr)
library(shiny)
library(shinyapps)
#library(shinydashboard)
library(Lahman)
library(RSQLite)

start <- Sys.time()
files <- c("inning/inning_hit.xml", "miniscoreboard.xml", "players.xml","inning/inning_all.xml")
my_db <- src_sqlite("MLB2014.sqlite3", create = TRUE)
scrape(start = "2016-04-03", end = "2016-11-03", connect = my_db$con, suffix = files)
end <- Sys.time()
print (end-start)

locations <- select(tbl(my_db, "hip",n=-1), des, x, y, batter, pitcher, type, team, inning, gameday_link)
locations <- as.data.frame(locations,n=-1)
batters <- select(tbl(my_db, "player",n=-1), first, last, id, bats, position, rl, team_abbrev)
batters <- as.data.frame(batters, n=-1)
batters$full.name <- paste(batters$first, batters$last, sep = " ")
names(batters)[names(batters) == 'id'] <- 'batter'
batters <- batters[,-c(1,2)]

batters <- batters[!duplicated(batters),]
locations <- locations[!duplicated(locations),]

spraychart <- merge(locations, batters, by="batter") 
names(spraychart)[names(spraychart) == 'des'] <- 'Description'
names(spraychart)[names(spraychart) == 'full.name'] <- 'Hitter'
pitchers <- batters[which(batters$position=='P'),]
names(pitchers)[names(pitchers)=='rl'] <- 'Pitch.throws'
names(pitchers)[names(pitchers)=='batter'] <- 'pitcher'
spraychart <- merge(spraychart,pitchers[,c(1,4,6)],by="pitcher")
spraychart <- spraychart[!duplicated(spraychart),]
names(spraychart)[names(spraychart) == 'full.name'] <- 'Pitcher'
spraychart <- spraychart[,-12]  ### remove the duplicated 'rl' column since we now have col's 'bats' and 'Pitch.throws' 


pitches <- select(tbl(my_db, "pitch",n=-1), 
                    pitch_type, px, pz, des, num, gameday_link, inning,start_speed)
pitches <- as.data.frame(pitches,n=-1)
pitches <- pitches[grepl('In play',pitches$des),]
names <- select(tbl(my_db, "atbat",n=-1), pitcher_name, batter_name, 
                num, b_height, gameday_link, event, stand)
names <- as.data.frame(names,n=-1)
que <- merge(pitches,names, by = c("num", "gameday_link"))
spraychart.combined <- merge(spraychart,que,by.x=c('gameday_link','inning'),by.y=c('gameday_link','inning'))
#que <- inner_join(pitches, filter(names),
#                  by = c("num", "gameday_link"),n=-1)
pitchfx <- collect(que)
last.pitch <- ddply(pitchfx, .(num), function(x) x[nrow(x), ])




