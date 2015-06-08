## inputs
chr.run.path <- "C:/Temp/PEST/BigElkPEST/hydrology/UpdatedMetWDM"
chr.uci.file <- "bigelk_org.uci"
chr.tsproc.file <- c("tsproc_obs.dat","tsproc_org.dat","tsproc_updt00.dat","tsproc_updt01.dat")
chr.file.model.out <- c("model_obs.out", "model_org.out", "model_updt00.out", "model_updt01.out")


## get simulation start date
chr.uci <- scan(file=paste0(chr.run.path,"/",chr.uci.file), what="char()",sep="\n")
dte.start <- as.Date(gsub("(^[ aA-zZ]{1,})|( 00:.*$)","", grep("^.*START",chr.uci,value=TRUE)),format="%Y/%m/%d")

## get tsproc input file
chr.tsproc.dat <- scan(file=paste0(chr.run.path,"/",chr.tsproc.file[1]),what="char()",sep="\n")
chr.new.tsproc <- grep("NEW_",chr.tsproc.dat, value=TRUE)
chr.data.tags <- read.table(text=gsub("^( ){1,}","",chr.new.tsproc), sep=" ",colClasses="character")[,-1]

## start data frame
df.data.flow <- data.frame(file="",type="",name="",date=as.Date("2999-01-01"),value=-9.9E-99,
                        comments="")

## process files and construct data frame for flow info
for(ii in seq(from=1, to=length(chr.file.model.out), by=1)) {
  ## get tsproc input file
  chr.tsproc.dat <- scan(file=paste0(chr.run.path,"/",chr.tsproc.file[ii]),what="char()",sep="\n")
  chr.new.tsproc <- grep("NEW_",chr.tsproc.dat, value=TRUE)
  chr.data.tags <- read.table(text=gsub("^( ){1,}","",chr.new.tsproc), sep=" ",colClasses="character")[,-1]
    
  ## read model out file
  tmp.data <- scan(file=paste0(chr.run.path,"/",chr.file.model.out[ii]),what="char()",sep="\n", blank.lines.skip=FALSE)
  
  ### data types and names
  tmp.info.df <- data.frame(headers=grep("^.*_.*\"" ,tmp.data,value=TRUE),
                            types=gsub("(\".*$)|( )","",grep("^.*_.*\"" ,tmp.data,value=TRUE)),
                            names=read.table(text=gsub("\"",",",grep("^.*_.*\"" ,tmp.data,value=TRUE)),sep=",",stringsAsFactors=FALSE)[,2],
                            stringsAsFactors=FALSE)
  
  ## get number of lines in data 
  tmp.nlines <- length(tmp.data)
  
  ## process tables for current file
  for(jj in seq(from=1, to=length(tmp.info.df[,1]), by=1)) {
    # header for table to be processed
    tmp.hdr <- tmp.info.df[jj,1]
    
    ## get time-series data
    if(tmp.info.df$types[jj] == "TIME_SERIES") { 
      tmp.ts.bg <- grep(tmp.hdr,tmp.data)+1
      tmp.ts.ed <- (grep("(^$)",tmp.data[tmp.ts.bg:length(tmp.data)])[1] - 2)+tmp.ts.bg
      if(is.na(tmp.ts.ed)) tmp.ts.ed <- tmp.nlines
      tmp.ts.df <- data.frame(file=chr.file.model.out[ii],type=tmp.info.df$types[jj],
                              name=tmp.info.df$name[jj],
                              date=seq(from=dte.start, to=dte.start + length(tmp.data[tmp.ts.bg:tmp.ts.ed]) - 1, by=1),
                              value=as.numeric(tmp.data[tmp.ts.bg:tmp.ts.ed]),
                              comments="none")
      df.data.flow <- rbind(df.data.flow,tmp.ts.df)
      rm(list=ls(pattern="tmp.ts"))
    }
    
    ## get volume accumulation data
    if(tmp.info.df$types[jj] == "V_TABLE") {
      tmp.vt.bg <- grep(tmp.hdr,tmp.data)+2
      tmp.vt.ed <- (grep("(^$)",tmp.data[tmp.vt.bg:length(tmp.data)])[1] - 2)+tmp.vt.bg
      if(is.na(tmp.vt.ed)) tmp.vt.ed <- tmp.nlines
      tmp.vt <- tmp.data[tmp.vt.bg:tmp.vt.ed]
      tmp.vt.row.seq <- seq(from=1,to=length(tmp.vt), by=1)
      tmp.vt.row <- rbind(
        data.frame(row = tmp.vt.row.seq,date=as.Date(gsub("(^.*From )|( 00:.*$)","",tmp.vt),format="%m/%d/%Y"),
                   value=as.numeric(gsub("(^.*volume.*=)|( {1,})","",tmp.vt)),comments="begin date",
                   stringsAsFactors=FALSE),
        data.frame(row = tmp.vt.row.seq,date=as.Date(gsub("(^.*to )|( 00:.*$)","",tmp.vt),format="%m/%d/%Y"),
                   value=as.numeric(gsub("(^.*volume.*=)|( {1,})","",tmp.vt)),comments="end date",
                   stringsAsFactors=FALSE))
      tmp.vt.row <- tmp.vt.row[order(tmp.vt.row$row),]
      tmp.vt.row <- tmp.vt.row[,-grep("row",names(tmp.vt.row))]
      tmp.vt.df <- cbind(file=chr.file.model.out[ii],type=tmp.info.df$types[jj],
                         name=tmp.info.df$name[jj],
                         tmp.vt.row, stringsAsFactors=FALSE)
      row.names(tmp.vt.df) <- NULL
      df.data.flow <- rbind(df.data.flow,tmp.vt.df)
      rm(list=ls(pattern="tmp.vt"))
    }
    
    ## get storm data
    if(tmp.info.df$types[jj] == "S_TABLE") {
      tmp.st.bg <- grep(tmp.hdr,tmp.data)+1
      tmp.st.ed <- (grep("(^$)",tmp.data[tmp.st.bg:length(tmp.data)])[1] - 2)+tmp.st.bg
      if(is.na(tmp.st.ed)) tmp.st.ed <- tmp.nlines
      tmp.st <- tmp.data[tmp.st.bg:tmp.st.ed]
      tmp.st.df <- rbind(
        data.frame(file=chr.file.model.out[ii],type=tmp.info.df$types[jj],name=tmp.info.df$name[jj],
                   date=as.Date(gsub("([aA-zZ]{1,})|( {1,})|(\\:)","",grep("[bB]eginning [dD]ate of [dD]ata [aA]ccumulation",tmp.st, value=TRUE)),format="%m/%d/%Y"),
                   value=as.numeric(gsub("([aA-zZ]{1,})|( {1,})|(\\:)","", grep("[mM]aximum [vV]alue", tmp.st,value=TRUE))),
                   comments= paste0("Begin date, Max storm flow, calculated from ",gsub("(^.*\\:)|( {1,})|(\")","", grep("[sS]eries [fF]or [wW]hich [dD]ata [cC]alculated", tmp.st,value=TRUE))),
                   stringsAsFactors=FALSE),
        data.frame(file=chr.file.model.out[ii],type=tmp.info.df$types[jj],name=tmp.info.df$name[jj],
                   date=as.Date(gsub("([aA-zZ]{1,})|( {1,})|(\\:)","",grep("[fF]inishing [dD]ate of [dD]ata [aA]ccumulation",tmp.st, value=TRUE)),format="%m/%d/%Y"),
                   value=as.numeric(gsub("([aA-zZ]{1,})|( {1,})|(\\:)","", grep("[mM]aximum [vV]alue", tmp.st,value=TRUE))),
                   comments= paste0("End date, Max storm flow, calculated from ",gsub("(^.*\\:)|( {1,})|(\")","", grep("[sS]eries [fF]or [wW]hich [dD]ata [cC]alculated", tmp.st,value=TRUE))),
                   stringsAsFactors=FALSE)
      )
      df.data.flow <- rbind(df.data.flow,tmp.st.df)
      rm(list=ls(pattern="tmp.st"))
    }
    
    ## get exceedance data
    if(tmp.info.df$types[jj] == "E_TABLE") {
      tmp.et.bg <- grep(tmp.hdr,tmp.data)+2
      tmp.et.ed <- (grep("(^$)",tmp.data[tmp.et.bg:length(tmp.data)])[1] - 2)+tmp.et.bg
      if(is.na(tmp.et.ed)) tmp.et.ed <- tmp.nlines
      tmp.et.raw.df <- read.table(text=gsub(" {1,}",",", gsub("(^ {1,})|( {1,}$)","", tmp.data[tmp.et.bg:tmp.et.ed])),sep=",",
                                  col.names=c("Flow","Time.delay.in.days","Time.above.in.days","Fraction.of.time.above.threshold"))
      tmp.et.df <- rbind(
        data.frame(file=chr.file.model.out[ii],type=tmp.info.df$types[jj],name=tmp.info.df$name[jj],
                   date=NA,
                   value=tmp.et.raw.df[,1],
                   comments= names(tmp.et.raw.df)[1],
                   stringsAsFactors=FALSE),
        data.frame(file=chr.file.model.out[ii],type=tmp.info.df$types[jj],name=tmp.info.df$name[jj],
                   date=NA,
                   value=tmp.et.raw.df[,3],
                   comments= names(tmp.et.raw.df)[3],
                   stringsAsFactors=FALSE),
        data.frame(file=chr.file.model.out[ii],type=tmp.info.df$types[jj],name=tmp.info.df$name[jj],
                   date=NA,
                   value=tmp.et.raw.df[,4],
                   comments= names(tmp.et.raw.df)[4],
                   stringsAsFactors=FALSE)
      )
      df.data.flow <- rbind(df.data.flow,tmp.et.df)
      rm(list=ls(pattern="tmp.et"))
    }  
  }
  rm(list=ls(pattern="tmp\\."))
}


## get rid of dummy first line
df.data.flow <- df.data.flow[-1,]

## get rid of empty levels
df.data.flow <- as.data.frame(lapply(df.data.flow,function(x) if(is.factor(x)) factor(x) else x))

## make sure the commnets column is string
df.data.flow$comments <- as.character(df.data.flow$comments)


