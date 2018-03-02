## download and unzip data set if not present already
if (!file.exists("exdata_data_household_power_consumption.zip")) {
        download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip", "exdata_data_household_power_consumption.zip")
}
unzip("exdata_data_household_power_consumption.zip", overwrite = FALSE)

##read top rows to speed up things
top_rows <- read.table(
        "household_power_consumption.txt",
        sep=";",
        dec=".",
        header=TRUE,
        nrow=1000,
        na.strings = "?"
)

## determine colClasses
column_classes <- sapply(top_rows, class)

## save column_names
column_names <- names(column_classes)

## lookup line numbers in data file for dates 2007-02-01 and 2007-02-02
## as per the assignment
date_filter <- grep("^(1\\/2\\/2007)|^(2\\/2\\/2007)",
                    readLines("household_power_consumption.txt"))

## calculate rows to skip
rows_to_skip <- date_filter[1]-1

## calculate number of rows to read
number_of_rows_to_read <- length(date_filter)

## read data
household_power_consumption <- read.table(
        "household_power_consumption.txt",
        sep=";",
        dec=".",
        header=TRUE,
        na.strings = "?",
        col.names = column_names,
        colClasses = column_classes,
        skip = rows_to_skip,
        nrows = number_of_rows_to_read
        )

## build additional DateTime column in POSIXct format
require(lubridate)

household_power_consumption$DateTime <-
        dmy_hms(
                paste(
                        household_power_consumption$Date ,
                        household_power_consumption$Time
                        )
                )
## force using internatinal locale to prevent local axis labels in plots
Sys.setlocale("LC_ALL","English")

## third plot
png(filename = "plot3.png", width=480, height=480)
plot(household_power_consumption$Sub_metering_1 ~
             household_power_consumption$DateTime,
     type="l", ylab="Energy sub metering", xlab="")
lines(household_power_consumption$Sub_metering_2 ~
              household_power_consumption$DateTime, col="red")
lines(household_power_consumption$Sub_metering_3 ~
              household_power_consumption$DateTime, col="blue")
legend("topright", c(1,2,3),
       c("Sub_metering_1","Sub_metering_2","Sub_metering_3"),
       lty=1, col=c("black", "red", "blue"))
dev.off()

