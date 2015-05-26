## paths
chr.run.path <- "C:/Temp/PEST/BigElkPEST/hydrology/UpdatedMetWDM"
setwd(chr.run.path)


## clear output from previous runs
if(file.exists("model.out")) file.remove("model.out")

## get obs flow
chr.tsproc.dat.obs <- scan(file="tsproc.dat",what="char()",sep="\n")
chr.list.output.obs <- chr.tsproc.dat.obs[(grep("START LIST_OUTPUT",chr.tsproc.dat.obs)+1):(grep("END LIST_OUTPUT",chr.tsproc.dat.obs)-1)]
chr.list.output.obs <- gsub(" m"," o",chr.list.output.obs)
chr.tsproc.dat.obs[(grep("START LIST_OUTPUT",chr.tsproc.dat.obs)+1):(grep("END LIST_OUTPUT",chr.tsproc.dat.obs)-1)] <- chr.list.output.obs
chr.tsproc.dat.obs[grep("FILE.*\\.out",chr.tsproc.dat.obs)] <- "  FILE model.out"
cat(chr.tsproc.dat.obs,file="tsprocobs.dat",sep="\n")
chr.tsproc.obs.cmd <- c("tsprocobs.dat","tsprocobs.dat","tsproc.rec","n","n")
system(command="tsproc",input=chr.tsproc.obs.cmd,wait=TRUE, show.output.on.console=TRUE)
file.rename(from="model.out", to="model_obs.out")



## run hspf for original met wdm file
chr.xhspfx.org.cmd <- c("bigelk.uci","bigelk.sup")
system(command="xhspfx",input=chr.xhspfx.org.cmd,wait=TRUE, show.output.on.console=FALSE)
chr.tsproc.org.cmd <- c("tsproc.dat","tsproc.dat","tsproc.rec","n","n")
system(command="tsproc",input=chr.tsproc.org.cmd,wait=TRUE, show.output.on.console=FALSE)
file.rename(from="model.out", to="model_org.out")

## run hspf using the updated met WDM file same simulation period as original WDM
chr.uci <- scan(file="bigelk.uci",what="char()", sep="\n")
## change WDM meteorological file
grep("WDM2       26", chr.uci, value=TRUE)
chr.uci <- gsub("WDM2       26   bigelk_in\\.wdm","WDM2       26   bigelkwqupdt\\.wdm",chr.uci)
cat(chr.uci,file="bigelkupd01.uci",sep="\n")
chr.xhspfx.update.cmd <- c("bigelkupd01.uci","bigelk.sup")
system(command="xhspfx",input=chr.xhspfx.update.cmd,wait=TRUE, show.output.on.console=FALSE)
chr.tsproc.update.cmd <- c("tsproc.dat","tsproc.dat","tsproc.rec","n","n")
system(command="tsproc",input=chr.tsproc.update.cmd,wait=TRUE, show.output.on.console=FALSE)
file.rename(from="model.out", to="model_upd01.out")

## run hspf using the updated met WDM file updated simulation period as original WDM
## change WDM meteorological file
grep("WDM2       26", chr.uci, value=TRUE)
chr.uci <- gsub("WDM2       26   bigelk_in\\.wdm","WDM2       26   bigelkwqupdt\\.wdm",chr.uci)
grep("WDM2       26", chr.uci, value=TRUE)
## change simulation period
chr.org.end.date <- "  START       1995/10/01 00:00  END    2010/12/31 24:00"
chr.update.end.date <- "  START       1995/10/01 00:00  END    2014/05/31 23:00"
grep("START", chr.uci, value=TRUE)
chr.uci <- gsub(chr.org.end.date,chr.update.end.date,chr.uci)
grep("START", chr.uci, value=TRUE)
cat(chr.uci,file="bigelkupd02.uci",sep="\n")
chr.xhspfx.update.cmd <- c("bigelkupd02.uci","bigelk.sup")
system(command="xhspfx",input=chr.xhspfx.update.cmd,wait=TRUE, show.output.on.console=FALSE)
chr.tsproc.update.cmd <- c("tsproc.dat","tsproc.dat","tsproc.rec","n","n")
system(command="tsproc",input=chr.tsproc.update.cmd,wait=TRUE, show.output.on.console=FALSE)
file.rename(from="model.out", to="model_upd02.out")

## Done
