
# set working directory to directory where script and data file reside
setwd("~/Documents/work/DataScience/repos/EDA")

# read in household_power_consumption.txt
# or just rows for dates: 2007-02-01 and 2007-02-02
hpc_df <- read.table("household_power_consumption.txt",
                     header=TRUE,
                     as.is = TRUE,
                     na.strings='?',
                     sep=';',
                     nrows=2075259,
                     colClasses = c("character","character", "numeric","numeric","numeric","numeric","numeric","numeric","numeric"))

# convert date field from factor to date
hpc_df$Date <- strptime(hpc_df$Date, "%d/%m/%Y")
# subset data for two days
hpc_df_days <- subset(hpc_df,Date==as.POSIXlt("2007-02-01") | Date==as.POSIXlt("2007-02-02"))

# write to png device
png(file="plot1.png",width=480,height=480)
# set margins and remove white background
par(mar=c(5,4,3,2), bg=NA)
#create histogram
hist(hpc_df_days$Global_active_power, col = "red", main="Global Active Power", xlab="Global Active Power (kilowatts)")

#to view on screen, uncomment next line
#dev.copy(png, file="plot1.png")
#close device
dev.off()

