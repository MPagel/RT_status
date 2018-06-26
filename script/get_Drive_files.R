library(here)
library(tidyverse)
library(googledrive)
library(lubridate)

# Things to work on:  1) write everything into a function or loop that can run on its own.
# 2) Figure out list input for receviers and Beacons
# 3) make in to Markdown doc with pretty table that coiuld be shared.
# 4) schedule tasks



# receiver inpout list (for later not currently using list, but will eventually want to loop it for all receivers in service)
#recs <- c('187027', '187028')

# search for recent files
files <- drive_find(pattern = '187027', n_max = 50) # use the rec serial number as the search parm, and limit the resutls to 50


# (1) Compare last upload time to current ---------------------------------
last_upload <- ymd_hms(substr(files$name[1], 8, 27)) # pull the date time of the most recent upload
current <- with_tz(Sys.time(), tzone = 'UTC') # current time (UTC)

time_since_up <- current-last_upload # elapsed time since last upload


# (2) Pull Diagnostic Data from most recent file --------------------------
drive_download(files$name[1], path = paste0('data/', files$name[1])) # download and store file
test <- read_csv('data/187027_2018_06_25__20_52_33.txt', col_names = F) # coerce txt file into csv
test[1, 17:18] # read the solar panel voltage and the battery voltage


# tilt info
tilt_index <- grep('TILT', test$X17, ignore.case = T) # index of rows with 'TILT'
values <- NULL # empty object to hold numeric tilt infor

# Pull out all tilt values, and average them
for(num in tilt_index){
  values <- c(values, (parse_number(test$X17[num])))
  mean_tilt <- mean(values)
}

# Beacon info
beac_dets <- length(grep("FF27", test$X5))

# number of dets not from the beacon tag
det_index <- which(nchar(test$X5)==4)
tags <- unique(test$X5[det_index])
alltags <- length(tags)-1

# how many other beacons
num_beacs <- grep("FF", tags)-1
 

# create empty df for reporting status
report <- data.frame(matrix(NA, 2, 8)) # empty table
names(report) <- c('RecSN', 'Time_Last_Up', 'Solar_Volt', 'Batt_Volt', 'Tilt', 
                   '#_Beacon_Dets', '#_Unique_Dets', '#_Other_Beacons')  # table headers

# start filling the table
report$RecSN[1] <- '187027' 
report$Time_Last_Up[1] <- time_since_up # see above code
report$Solar_Volt[1] <- test$X17[1]
report$Batt_Volt[1] <- test$X18[1]
report$Tilt[1] <-mean_tilt # add average tilt value to the table
report$`#_Beacon_Dets`[1] <- beac_dets
report$`#_Unique_Dets`[1] <- alltags
report$`#_Other_Beacons`[1] <- num_beacs

write_csv(report, paste0("data_output/", Sys.Date(), "_RealTimeReport.csv"))


