#install.packages("install.load") #comment this line after running the script for the first time.
#tried using dplyr for this at first but it has no intuitive way to create variables on the fly
#changed over to data.table in the end to make it easier
# library(install.load)
# library(ggplot2)
library(data.table)
library(lubridate)

# install_load("gridExtra","ggthemes")
# install_load("RColorBrewer","wesanderson")
library(tidyverse)
#don't include the extension or folder in the file name. It assumes it's a csv in the data folder
FILE_NAME <- 'tabula-Production-List-20200906'
GREP_INCLUDE <- "^[[:upper:][:space:][:punct:]]+$|SEASON [1-9]{1}|MARTHA'S VINEYARD MYSTERIES|^J$"
JUNK_TO_REMOVE <- "^J$|^LS$|^TAD$"
GREP_DATES <- "^[[:upper:]]{1}[[:lower:]]{2}[[:space:]]{1,2}\\d{2}"
DATE_SPLIT_CHARACTERS <- " - | TAD | \\("

productionData_raw <- read_csv(paste0('data/',FILE_NAME,'.csv'), col_names = FALSE)
productionData_raw %>% tbl_df %>% print(n=25)
# productionData_raw[grepl("^[A-Z, 0-9]+$",productionData_raw$X1),]$X1

# production names in this data are in all caps and numbers mostly so use grep to tease them out.
# might need to add a couple of specific titles if they aren't being recognized
names <- productionData_raw[grepl(GREP_INCLUDE,
                         productionData_raw$X1),]$X1
# remove any unwanted junk that got classified as a production title
# might need to change this if there is some new format of junk.
names <- grep(JUNK_TO_REMOVE, names, invert=TRUE,value = TRUE)

# get the start and end dates in their own columns
#this seems to work pretty well. Sometimes end up with some junk tagged onto the end.
# the str_split function can have different separators added to reemove the junk at the end.
# make sure that the \\( delimiter is put last. For some reason if it's not last it doesn't work properly.
dates <- grep(GREP_DATES,productionData_raw$X1, value=TRUE)
datesList <- dates %>% str_split(DATE_SPLIT_CHARACTERS)
# as_tibble(datesList)

startAndEndDates <- list()

# put each of the start and end dates in a column
# just use 1:2 to remove the junk at the end
 for(val in 1:2){
startAndEndDates[[val]] <- sapply(datesList, `[[`, val)
  
}

#print out both of the dates variables to see if they came out ok
# (should have the same number of rows as there are productions)
datesList
startAndEndDates

productions <- tibble(name = names,
      start_date = mdy(startAndEndDates[[1]]),
      end_date = mdy(startAndEndDates[[2]]))



write_csv(productions,paste0('./data/cleanded',FILE_NAME,'.csv'))

productions
rm(list = grep("FILE_NAME|productions", ls(),value=TRUE, invert=TRUE))

# grep("FILE_NAME|productions", ls(),value=TRUE, invert=TRUE)

