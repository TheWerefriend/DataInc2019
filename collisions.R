library(tidyr)
library(purrr)
library(dplyr)
library(lubridate)

# Load the file
setwd("~/Desktop/di")
dump <- data.frame(read.csv(file="collisions.csv",
			header=TRUE, sep=","))

# Cut observations after 2018
dump$DATE <- as.Date(dump$DATE, format = "%m/%d/%Y")
dump <- dump %>% filter(DATE <= "2018-12-31")

# Remove NA from injured persons (total 368034)
d <- dump$NUMBER.OF.PERSONS.INJURED
d[is.na(d)] <- 0
sum(is.na(d))
sum(d)

# Count the cyclists' bad days (29061)
cyclists <- 0
for (i in 1:nrow(dump)) {
    if (dump$NUMBER.OF.CYCLIST.KILLED[i] +
    	dump$NUMBER.OF.CYCLIST.INJURED[i] != 0) {
    cyclists <- cyclists + 1
	}
}

cyclists / nrow(dump)
# 0.02046199

# Count Brooklyn (0.1617948)
dump16 <- filter(dump, dump$DATE > "2015-12-31")
dump16 <- filter(dump16, dump16$DATE < "2017-01-01")
bkln16 <- filter(dump16, dump16$BOROUGH == "BROOKLYN") 
notNull16 <- filter(dump16, is.na(dump16$BOROUGH) != TRUE)
nrow(notNull16) / nrow(dump)

# Count alcohol up the boroughs
pop17 <- c(1471160,2648771,1664727,2358582,479458)
boroughs <- c("BRONX","BROOKLYN","MANHATTAN","QUEENS","STATEN ISLAND")
names(pop17) <- boroughs

dump17 <- filter(dump, dump$DATE > "2016-12-31")
dump17 <- filter(dump17$DATE < "2018-01-01")
bkln17 <- filter(dump17, dump17$BOROUGH == "BROOKLYN")
brnx17 <- filter(dump17, dump17$BOROUGH == "BRONX")
mntn17 <- filter(dump17, dump17$BOROUGH == "MANHATTAN")
quns17 <- filter(dump17, dump17$BOROUGH == "QUEENS")
sttn17 <- filter(dump17, dump17$BOROUGH == "STATEN ISLAND")

# Count alcohol related collisions (0.0003712525 per capita)
bklnalc <- sum(nrow(filter(bkln17, bkln17$CONTRIBUTING.FACTOR.VEHICLE.1 == "Alcohol Involvement")),
	nrow(filter(bkln17, bkln17$CONTRIBUTING.FACTOR.VEHICLE.2 == "Alcohol Involvement")),
	nrow(filter(bkln17, bkln17$CONTRIBUTING.FACTOR.VEHICLE.3 == "Alcohol Involvement")),
	nrow(filter(bkln17, bkln17$CONTRIBUTING.FACTOR.VEHICLE.4 == "Alcohol Involvement")),
	nrow(filter(bkln17, bkln17$CONTRIBUTING.FACTOR.VEHICLE.5 == "Alcohol Involvement")))
brnxalc <- sum(nrow(filter(brnx17, brnx17$CONTRIBUTING.FACTOR.VEHICLE.1 == "Alcohol Involvement")),
	nrow(filter(brnx17, brnx17$CONTRIBUTING.FACTOR.VEHICLE.2 == "Alcohol Involvement")),
	nrow(filter(brnx17, brnx17$CONTRIBUTING.FACTOR.VEHICLE.3 == "Alcohol Involvement")),
	nrow(filter(brnx17, brnx17$CONTRIBUTING.FACTOR.VEHICLE.4 == "Alcohol Involvement")),
	nrow(filter(brnx17, brnx17$CONTRIBUTING.FACTOR.VEHICLE.5 == "Alcohol Involvement")))
mntnalc <- sum(nrow(filter(mntn17, mntn17$CONTRIBUTING.FACTOR.VEHICLE.1 == "Alcohol Involvement")),
	nrow(filter(mntn17, mntn17$CONTRIBUTING.FACTOR.VEHICLE.2 == "Alcohol Involvement")),
	nrow(filter(mntn17, mntn17$CONTRIBUTING.FACTOR.VEHICLE.3 == "Alcohol Involvement")),
	nrow(filter(mntn17, mntn17$CONTRIBUTING.FACTOR.VEHICLE.4 == "Alcohol Involvement")),
	nrow(filter(mntn17, mntn17$CONTRIBUTING.FACTOR.VEHICLE.5 == "Alcohol Involvement")))
qunsalc <- sum(nrow(filter(quns17, quns17$CONTRIBUTING.FACTOR.VEHICLE.1 == "Alcohol Involvement")),
	nrow(filter(quns17, quns17$CONTRIBUTING.FACTOR.VEHICLE.2 == "Alcohol Involvement")),
	nrow(filter(quns17, quns17$CONTRIBUTING.FACTOR.VEHICLE.3 == "Alcohol Involvement")),
	nrow(filter(quns17, quns17$CONTRIBUTING.FACTOR.VEHICLE.4 == "Alcohol Involvement")),
	nrow(filter(quns17, quns17$CONTRIBUTING.FACTOR.VEHICLE.5 == "Alcohol Involvement")))
sttnalc <- sum(nrow(filter(sttn17, sttn17$CONTRIBUTING.FACTOR.VEHICLE.1 == "Alcohol Involvement")),
	nrow(filter(sttn17, sttn17$CONTRIBUTING.FACTOR.VEHICLE.2 == "Alcohol Involvement")),
	nrow(filter(sttn17, sttn17$CONTRIBUTING.FACTOR.VEHICLE.3 == "Alcohol Involvement")),
	nrow(filter(sttn17, sttn17$CONTRIBUTING.FACTOR.VEHICLE.4 == "Alcohol Involvement")),
	nrow(filter(sttn17, sttn17$CONTRIBUTING.FACTOR.VEHICLE.5 == "Alcohol Involvement")))

alc <- c(brnxalc,bklnalc,mntnalc,qunsalc,sttnalc)
perCap <- pop17 / alc

# Filter 2013 to 2018, 
series <- filter(dump, dump$DATE > "2012-12-31")
allDates <- data.frame(series$DATE)
uniqueDates <- unique(series$DATE)
df <- data.frame(dates = uniqueDates, count = 1)

for (i in 1:nrow(allDates)) {
	if (allDates[i] == allDates[i-1]) {
		df$count <- df$count + 1
	}
}