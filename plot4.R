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
png(filename = "plot4.png", width = 480, height = 480)
par(mfrow = c(2,2))
with(household, {
    # Plot Top Left
    plot(Date, Global_active_power, xlab = "", ylab = "Global Active Power", type = "n")
    par(pch = ".")
    points(Date, Global_active_power, type = "l", col = "black")
    # Plot Top Right
    plot(Date, Voltage, xlab = "datetime")
    par(pch = ".")
    points(Date, Voltage, type = "l", col = "black")
    # Plot Bottom Left
    plot(Sub_metering_1 ~ Date, ylab = "Energy sub metering", xlab = "", type = "n")
    par(pch = ".", col = "black")
    points(Date, Sub_metering_1, type = "l", col = "black")
    points(Date, Sub_metering_2, type = "l", col = "red")
    points(Date, Sub_metering_3, type = "l", col = "blue")
    legend("topright", pch = NA, col = c("black","red","blue"), legend = c("Sub_metering_1","Sub_metering_2","Sub_metering_3"), bty = "n", lwd = 2, cex = 1)
    # Plot Bottom Right
    plot(Date, Global_reactive_power, xlab = "datetime")
    par(pch = ".")
    points(Date, Global_reactive_power, type = "l", col = "black")
})
# Flush the PNG file
dev.off()