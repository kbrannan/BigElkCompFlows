## paths
chr.run.path <- "C:/Temp/PEST/BigElkPEST/hydrology/UpdatedMetWDM"
setwd(chr.run.path)

## get simulation start date
chr.uci.file <- "bigelk.uci"
chr.uci <- scan(file=chr.uci.file, what="char()",sep="\n")
dte.start <- as.Date(gsub("(^[ aA-zZ]{1,})|( 00:.*$)","", grep("^.*START",chr.uci,value=TRUE)),format="%Y/%m/%d")

## get tsproc input file
chr.tsproc.dat <- scan(file="tsproc.dat",what="char()",sep="\n")
chr.new.tsproc <- grep("NEW_",chr.tsproc.dat, value=TRUE)

chr.data.tags.obs <- grep("^o",read.table(text=gsub("^( ){1,}","",chr.new.tsproc), sep=" ",colClasses="character")[,-1],value=TRUE)
chr.data.tags.model <- grep("^m",read.table(text=gsub("^( ){1,}","",chr.new.tsproc), sep=" ",colClasses="character")[,-1],value=TRUE)

## files with flow output
chr.file.flow.obs <- "model_obs.out"
chr.file.flow.org <- "model_org.out"
chr.file.flow.upd.wdm <- "model_upd01.out"
chr.file.flow.upd.wdm.date <- "model_upd01.out"

## read in flow data
chr.data.obs <- scan(chr.file.flow.obs,what="char()",sep="\n", blank.lines.skip=FALSE)
chr.data.org <- scan(chr.file.flow.org,what="char()",sep="\n", blank.lines.skip=FALSE)
chr.data.upd.wdm <- scan(chr.file.flow.upd.wdm,what="char()",sep="\n", blank.lines.skip=FALSE)
chr.data.upd.wdm.date <- scan(chr.file.flow.upd.wdm.date,what="char()",sep="\n", blank.lines.skip=FALSE)

## current data file
tmp.data <- chr.data.obs

### data types and names
df.info <- data.frame(headers=grep("^.*_.*\"" ,tmp.data,value=TRUE),
                      types=gsub("(\".*$)|( )","",grep("^.*_.*\"" ,tmp.data,value=TRUE)),
                      names=read.table(text=gsub("\"",",",grep("^.*_.*\"" ,tmp.data,value=TRUE)),sep=",",stringsAsFactors=FALSE)[,2],
                      stringsAsFactors=FALSE)
## get number of lines in data 
tmp.nlines <- length(tmp.data)

# header for table to be processed
tmp.hdr <- df.info[1,1]

## get time-series data
tmp.bg <- grep(tmp.hdr,tmp.data)+1
tmp.ed <- (grep("(^$)",tmp.data[tmp.bg:length(tmp.data)])[1] - 2)+tmp.bg
if(is.na(tmp.ed)) tmp.ed <- tmp.nlines
tmp.ts.df <- data.frame(file=)
tmp.ts.value <- tmp.data[tmp.bg:tmp.ed]
tmp.ts.date  <- seq(from=dte.start, to=dte.start + length(tmp.ts.value) - 1, by=1)


## get storm data
tmp.bg <- grep(tmp.hdr,tmp.data)+1
tmp.ed <- (grep("(^$)",tmp.data[tmp.bg:length(tmp.data)])[1] - 2)+tmp.bg
if(is.na(tmp.ed)) tmp.ed <- tmp.nlines
tmp.ts <- tmp.data[tmp.bg:tmp.ed]

## get volume accumulation data
tmp.bg <- grep(tmp.hdr,tmp.data)+2
tmp.ed <- (grep("(^$)",tmp.data[tmp.bg:length(tmp.data)])[1] - 2)+tmp.bg
if(is.na(tmp.ed)) tmp.ed <- tmp.nlines
tmp.ts <- tmp.data[tmp.bg:tmp.ed]

## get exceedance data
tmp.bg <- grep(tmp.hdr,tmp.data)+2
tmp.ed <- (grep("(^$)",tmp.data[tmp.bg:length(tmp.data)])[1] - 2)+tmp.bg
if(is.na(tmp.ed)) tmp.ed <- tmp.nlines
tmp.ts <- tmp.data[tmp.bg:tmp.ed]

