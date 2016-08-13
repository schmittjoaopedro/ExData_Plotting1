# Download required libraries
library(dplyr)
library(lubridate)

# Location where the dataset is available
datasetURL <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"

# Tidy the dataset of the household_power_consumption
if(!file.exists("tidy.csv")) {
    # Download it if the dataset does not exist
    if(!file.exists("data")) {
        dir.create("data")
        download.file(datasetURL, destfile = file.path("data","dataset.zip"))
    }
    # Extract the dataset
    if(!file.exists(file.path("data","household_power_consumption.txt"))) {
        unzip(file.path("data","dataset.zip"), exdir = file.path("data"))
    }
    # Load and tidy the dataset, filter by date, convert the date to Date/Time
    household <- read.csv(file.path("data","household_power_consumption.txt"), na.strings = "?", sep = ";")
    household <- household %>% filter(dmy(Date) %in% c(dmy("01/02/2007"),dmy("02/02/2007")))
    household$Date <- dmy_hms((paste(household$Date,household$Time)))
    household <- household %>% select(-(Time))
    # Write the tidy dataset
    write.csv(household, "tidy.csv", row.names = F)
}
# Load the tidy dataset
household <- read.csv("tidy.csv")
household$Date <- ymd_hms(household$Date)

# Create an PNG file
png(filename = "plot3.png", width = 480, height = 480)
# Create the chart
with(household, plot(Sub_metering_1 ~ Date, ylab = "Energy sub metering", xlab = "", type = "n"))
par(pch = ".", col = "black")
with(household, points(Date, Sub_metering_1, type = "l", col = "black"))
with(household, points(Date, Sub_metering_2, type = "l", col = "red"))
with(household, points(Date, Sub_metering_3, type = "l", col = "blue"))
legend("topright", pch = NA, col = c("black","red","blue"), legend = c("Sub_metering_1","Sub_metering_2","Sub_metering_3"), lwd = 2, cex = 1)
# Flush the PNG file
dev.off()