## paths
chr.wdm.path <-  "C:/Temp/PEST/BigElkPEST/hydrology/UpdatedMetWDM"
chr.Winhspf.path <- "C:/BASINS41/models/HSPF/bin/"

setwd(chr.wdm.path)

## set working directory to where the wdm files are. I have a problem with the 
## paths within the tsproc

## system command strings
chr.cmd <- paste0(chr.Winhspf.path,"C:/BASINS41/models/HSPF/bin/WinHspfLt.exe -1 -1")

## file names
chr.uci <- c("bigelk_org","bigelk_updt00","bigelk_updt01")
chr.tsproc <- c("tsproc_obs","tsproc_org","tsproc_updt00","tsproc_updt01")

## get obs flow
chr.tsproc.obs.cmd <- c(paste0(chr.wdm.path,"/","tsproc.exe "),
                        paste0(chr.wdm.path,"/",chr.tsproc[1],".dat "),
                        paste0(chr.wdm.path,"/",chr.tsproc[1],".rec"),
                        "n","n")
system(command=chr.tsproc.obs.cmd[1],input=chr.tsproc.obs.cmd[2:5],wait=TRUE, show.output.on.console=FALSE)


## run hspf for original met wdm file and get output
chr.WinhspfLt.org.cmd <- paste0(chr.hspf.path,"/","WinHspfLt.exe -1 -1 ",chr.wdm.path,"/",chr.uci[1],".uci")
system(command=chr.WinhspfLt.org.cmd, wait=TRUE)

chr.tsproc.obs.cmd <- c(paste0(chr.wdm.path,"/","tsproc.exe "),
                        paste0(chr.wdm.path,"/",chr.tsproc[2],".dat "),
                        paste0(chr.wdm.path,"/",chr.tsproc[2],".rec"),
                        "n","n")
system(command=chr.tsproc.obs.cmd[1],input=chr.tsproc.obs.cmd[2:5],wait=TRUE, show.output.on.console=FALSE)


## run hspf for updated met wdm file with original simulation period and get output
chr.WinhspfLt.org.cmd <- paste0(chr.hspf.path,"/","WinHspfLt.exe -1 -1 ",chr.wdm.path,"/",chr.uci[2],".uci")
system(command=chr.WinhspfLt.org.cmd, wait=TRUE)

chr.tsproc.obs.cmd <- c(paste0(chr.wdm.path,"/","tsproc.exe "),
                        paste0(chr.wdm.path,"/",chr.tsproc[3],".dat "),
                        paste0(chr.wdm.path,"/",chr.tsproc[3],".rec"),
                        "n","n")
system(command=chr.tsproc.obs.cmd[1],input=chr.tsproc.obs.cmd[2:5],wait=TRUE, show.output.on.console=FALSE)

## run hspf for updated met wdm file with new simulation period and get output
chr.WinhspfLt.org.cmd <- paste0(chr.hspf.path,"/","WinHspfLt.exe -1 -1 ",chr.wdm.path,"/",chr.uci[3],".uci")
system(command=chr.WinhspfLt.org.cmd, wait=TRUE)

chr.tsproc.obs.cmd <- c(paste0(chr.wdm.path,"/","tsproc.exe "),
                        paste0(chr.wdm.path,"/",chr.tsproc[4],".dat "),
                        paste0(chr.wdm.path,"/",chr.tsproc[4],".rec"),
                        "n","n")
system(command=chr.tsproc.obs.cmd[1],input=chr.tsproc.obs.cmd[2:5],wait=TRUE, show.output.on.console=FALSE)

## Done
