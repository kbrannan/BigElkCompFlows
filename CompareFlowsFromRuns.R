library(doBy)

str(df.data.flow)

head(df.data.flow[df.data.flow$types=="",])

junk <- as.data.frame(
  lapply(df.data.flow, 
         function(x) if(is.factor(x)) factor(x) else x
  )
)


levels(junk$type)
levels(df.data.flow$type)
unique(as.character((df.data.flow[df.data.flow$type=="V_TABLE",]$name)))
summaryBy(value ~ file + name, data=df.data.flow[df.data.flow$type=="V_TABLE",],FUN=sum)
