library(doBy)
library(ggplot2)
##library(extrafont)






## if you haven't imported all your fonts to R, run the font_import command below
##font_import()
# if("xkcd" %in% fonts() != TRUE) {
#   download.file("http://simonsoftware.se/other/xkcd.ttf",
#                 + dest="c:/wondws/fonts/xkcd.ttf", mode="wb")
#   font_import(pattern = ".*kcd", prompt=FALSE) 
# }




## convert drainage area of Big Elk Creek from sqr mi to acres-ft using 1 acre = 43560 sqr ft
df.summ00 <- summaryBy((value/43560) ~ file + name, 
                       data=df.data.flow[df.data.flow$type=="V_TABLE" & 
                                           df.data.flow$comments=="begin date",],
                       FUN=c(sum,mean), var.names="vol.ac.ft")

df.summ00 <- cbind(df.summ00,period=factor(gsub("^.*_","", as.character(df.summ00$name)),levels=unique(gsub("^.*_","", as.character(df.summ00$name)))))


## plots of totals
p00 <- ggplot(data=df.summ00) + 
  geom_bar(aes(x=file,y=vol.ac.ft.sum,fill=file),stat="identity") +
  facet_grid(~period)
plot(p00)  

p01 <- ggplot(data=df.summ00) + 
  geom_bar(aes(x=file,y=vol.ac.ft.mean,fill=file),stat="identity") +
  facet_grid(~period)
plot(p01)  


