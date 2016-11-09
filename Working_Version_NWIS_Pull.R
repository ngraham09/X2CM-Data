### Can also add in multiple sites with c() fx
#### working Code for Jersey Point with all parameter codes
## Stations: JPT= 11337190, FPT= 11447650, WGA= 11447890, TOE= 11455139, DWS= 11455142, LCT= 11455146
## LIB= 11455315, CCH= 11455350, DEC= 11455478, CFL= 11455508
## 11447650', '11455139','11455142','11455146','11455315','11455350','11455478','11455508'
library(stringr)
library(dataRetrieval)

#start function 1
parametercd<- c("63680","00010","00095","00400", "32315","95204", "32315","32295", "00300", "00301", "99133", "00060")
siteNumbers<-c('11455139')
startDate<-'2016-10-08'
endDate<-''
# 

  rawNWISdata<-readNWISuv(siteNumbers,parametercd,startDate,endDate,tz="America/Los_Angeles")
  # statisticInfo<-attr(rawNWISRealData, "statisticinfo")
  # variableInfo2<-attr(rawNWISRealData, "variableInfo")
  # SiteInfo<-attr(rawNWISRealData,"siteinfo")
  #end function 1
  #see what params available
  
  #start function 2
  # "Name"<-function(rawNWISdata){
  
  
  
  #get the names of the cols
  cols<-colnames(rawNWISdata)
  #ID cols to keep
  #boolean array of BGC cols 
  bgc_cols<-str_detect(cols,"BGC")
  #boolean array of discharge cols 
  Q_col<-str_detect(cols,"X_00060_00000")
  #boolean array of datetime col 
  datetime_col<-str_detect(cols,"dateTime")
  #boolean array of site_no col 
  stations_col<-str_detect(cols,"site_no")
  #boolean and of keep arrays
  CDOM_col<-str_detect(cols,"_32295_00000")
  keep_cols = bgc_cols | Q_col | datetime_col | stations_col | CDOM_col
  #subselect colsumns based on boolean array of keep cols
  rawNWISdata_keep = subset(rawNWISdata,select = keep_cols)
  # 
  #

  #Renaming of Data Columns 
  renamedNWISraw<-renameNWISColumns(rawNWISdata_keep, p63680 = " Turb (FNU)", p00010 = "Temp (deg C)", p00095 = "SpC (uS/cm)", p00400 = "pH", p32315 = "Chl-a (RFU)", p00300 = "DO (mg/L)", p00301 = "DO (%Sat)", p32295 = "CDOM (ppb QSE)" , p99133 = "SUNA (mg/L as N)", p00060 = "Discharge (cfs)")

  
   ##Removing "BGC.PROJECT_" from column title" 
  names(rawNWISdata_keep)<-sub("BGC.Project","Discharge (cfs)\\",names(rawNWISdata_keep))
  ## Removing "_00000" from column title
  names(renamedNWISraw)<-sub("_00000","",names(renamedNWISraw))
  ##CDOM Name change adjusment
  names(renamedNWISraw)<-sub(".Corrected._","",names(renamedNWISraw))
  
  
  
  
  ##Giving final renamed Data fram new name
  FinalNWISraw=renamedNWISraw                              
                                
  #end function 2
  
  path <- 'C:/Users/ngraham/Documents/BGC/NWIS Data/'
  output_filename <- paste(path,siteNumbers,'.csv',sep="")
  write.csv(x = FinalNWISraw,file = output_filename)
  



