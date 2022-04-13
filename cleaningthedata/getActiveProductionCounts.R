#run cleanFall2020Productions.R script to get to starting point
#this script uses two variables from previoius script: productions and FILE_NAME

# mdy("jan-19-1988") %>% typeof()
# 
# testDates <- c("jan-19-1988", "mar-12-1990") %>% mdy() 
# seq.Date(testDates[1], testDates[2],by=1)
# min(productions$start_date)
# max(productions$end_date)
# summarise(productions)
# 
# 5%%2
# 
# testDates[1] - testDates[2] > 0
# 
# pointDate = mdy("jan-19-2021")
dateSeq <- seq.Date(min(productions$start_date), max(productions$end_date),by=1)


# dateGreaterThan <- pointDate > dateSeq
# sum(dateGreaterThan)
# 
# between(pointDate,productions$start_date,productions$end_date)
# between(dateSeq,productions$start_date[1],productions$end_date[1])
# count(productions) %>% typeof()
# n(productions)
# 
# version(dplyr)
# packageVersion("dplyr")
# 
# vignette("programming", "dplyr")
# 
# dateOfinterest = "2020-09-01"
# enquo(dateOfinterest)
# quo_name(dateOfinterest)
# 
# quo(!!dateOfinterest)
# productions %>% mutate(quo_name(dateOfinterest) = 1)
# 
# datatable = as.data.table((productions))
# 
# datatable[,(as.character(dateSeq[65])) := (dateSeq[65] >= start_date & dateSeq[65] <= end_date)]
# 
# datatable[,.(start_date, end_date,`2020-09-01`)]
# 
# dateSeq[81]
# 
# vignette(package="data.table")
# 
# datatable[,..N]
# 
# fwrite(datatable,"./data/testDataTable.csv")
datatable = as.data.table((productions))
MOWdatatable = copy(datatable)
dateSeq[5] - dateSeq[4] == 1
for(x in 1:length(dateSeq)){
  # print(dateSeq[x])
  MOWdatatable[,(as.character(dateSeq[x])) := 
              (dateSeq[x] >= start_date & 
                 dateSeq[x] <= end_date & 
                 end_date - start_date <= 21)]
   datatable[,(as.character(dateSeq[x])) := (dateSeq[x] >= start_date & dateSeq[x] <= end_date)]
  # datatable[,(as.character(x)) := "fart"]
}
# 
# datatable[,(dateSeq[1] >= start_date )]
# dateSeq[1:10]
# datatable[41,]
# 
# datatable[name == "BONFIRE"]

fwrite(datatable,paste0('./data/',FILE_NAME,"WithActiveProductionbyDate.csv"))

days <- datatable[,4:(length(datatable))
          ][
            ,lapply(.SD, sum, na.rm=TRUE)
          ]
fwrite(melt(days,id.vars = "2020-06-29")[,2:3],
       paste0("./data/",FILE_NAME,"activeProductionsperDay.csv"))

MOWdays <- MOWdatatable[,4:(length(datatable))
                  ][
                    ,lapply(.SD, sum, na.rm=TRUE)
                    ]

fwrite(melt(MOWdays,id.vars = "2020-06-29")[,2:3],
       paste0("./data/MOW",FILE_NAME,"activeProductionsperDay.csv"))



