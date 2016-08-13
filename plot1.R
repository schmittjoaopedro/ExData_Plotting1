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
png(filename = "plot1.png", width = 480, height = 480)
# Create the chart
with(household, hist(Global_active_power, col = "red", main = "Global Active Power", xlab = "Global Active Power (kilowatts)"))
# Flush the PNG file
dev.off()