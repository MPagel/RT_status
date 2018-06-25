library(here)
library(tidyverse)
library(googledrive)
library(lubridate)




# receiver inpout list (for later not currently using list, but will eventually want to loop it for all receivers in service)
#recs <- c('187027', '187028')

# search for recent files
files <- drive_find(pattern = '187027', n_max = 50) # use the rec serial number as the search parm, and limit the resutls to 50


# (1) Compare last upload time to current ---------------------------------
last_upload <- ymd_hms(substr(files$name[1], 8, 27)) # pull the date time of the most recent upload
current <- with_tz(Sys.time(), tzone = 'UTC') # current time (UTC)

current-last_upload # elapsed time since last upload


# (2) Pull Diagnostic Data from most recent file --------------------------
drive_download(files$name[1], path = paste0('data/', files$name[1])) # download and store file
test <- read_csv('data/187027_2018_06_25__20_52_33.txt', col_names = F) # coerce txt file into csv
test[1, 17:18] # read the solar panel voltage and the battery voltage


