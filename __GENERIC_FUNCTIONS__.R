#ORTHOWATCH
if(.Platform$OS.type == "unix") {dir.ow.syno<-'/export/globcrop/RW_Orthowatch'
dir.fig<-'/home/dandrimont/Dropbox/Ch3/PaperOW/Figs/'
dir.ow.oasis<-'/export/eli-enge-Orthowatch-rw-2014/'}
if (.Platform$OS.type == "windows") { dir.ow.syno<-'Q:/RW_Orthowatch'
dir.ow.oasis<-'T:/'}

#########################
#SIGMA
if(.Platform$OS.type == "unix") {dir.syno<-'/export/globcrop/'}
if (.Platform$OS.type == "windows") { dir.syno<-'Q:/'}

#===================================

# Check paskage install and load
packageNeeded=c('raster','rgdal','doSNOW','foreach','formatR','knitr','rgl','snow','parallel','data.table','plyr','rgeos','ggplot2','XML')
# chekck installed package and install the package if needed
for (package in packageNeeded){  if (package %in% rownames(installed.packages())==FALSE)
{install.packages(package,repos='http://cran.us.r-project.org')}}

# load the packages
lapply(packageNeeded, require, character.only = TRUE)

#===================================
# Localisation des bin OTB selon la machine

if (system('uname -n',intern=T) == "eliegeo06.oasis.uclouvain.be") {
  serv_name<-'six'
  serv_num<-6}
if (system('uname -n',intern=T) == "eliegeo07") {
  serv_name<-'sept'
  serv_num<-7}
if (system('uname -n',intern=T) == "gpunode01.elie") {
  serv_name<-'huit'
  serv_num<-8}

path.bin_otb<-paste('/home/OASIS/julien/',serv_name,'/OTBbin/bin/',sep='')


# si otb installé en global
if (system('uname -n',intern=T) == "dandrimont") {
  path.bin_otb<-'/usr/bin/'}

if (system('uname -n',intern=T) == "dandrimont") {
  path.bin_otb<-'/home/dandrimont/OTB/build/OTB/build/bin/'}

#########################

addColorTable <- function(inRstName, outRstName, colT, attT){
  library(rgdal)
  r<- readGDAL(inRstName)
  writeGDAL(r, outRstName, type="Byte", colorTable=list(colT), catNames=list(attT), mvFlag=11L)
}

addQuickLook<-function(inRstName,outRstName,percent=10){
  system(
    paste('gdal_translate',
          '-of','PNG',
          '-outsize',paste(percent,'%',sep=''),paste(percent,'%',sep=''),
          inRstName,outRstName))
}

addHistogram<-function(inRstName){
  system(paste('gdalinfo -hist -stats',inRstName))}

addPyramids<-function(inRstName){
  system( paste('gdaladdo --config USE_RRD YES',inRstName,'2 4 8 16'))}

colT <- c('white','yellow','white','red','blue')
attT <- c('no water','omission','-','commission','water both')

colT6cl <- c('black','blue','dark green','yellow','light green','red','grey')
attT6cl <- c('none','eau','foret','culture','prairie','bati' ,'ombre')
