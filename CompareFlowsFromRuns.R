library(doBy)

str(df.data.flow)

levels(df.data.flow$name)

levels(df.data.flow$file)

unique(df.data.flow$comments)

head(df.data.flow[df.data.flow$types=="",])


## convert drainage area of Big Elk Creek from sqr mi to acres-ft using 1 acre = 43560 sqr ft
summaryBy((value/43560) ~ file + name, data=df.data.flow[df.data.flow$type=="V_TABLE" & df.data.flow$comments=="begin date",],FUN=sum)
