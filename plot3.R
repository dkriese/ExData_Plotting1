
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

# create new dataframe with timestamp column
hpc_timestamp <- within(hpc_df_days, { timestamp=format(as.POSIXct(paste(Date, Time)), "%Y-%m-%d %H:%M:%S") })

# create timeseries objects for plotting
hpc_sm1 <- ts(hpc_timestamp$Sub_metering_1, frequency=3, start=c(1,1))
hpc_sm2 <- ts(hpc_timestamp$Sub_metering_2, frequency=3, start=c(1,1))
hpc_sm3 <- ts(hpc_timestamp$Sub_metering_3, frequency=3, start=c(1,1))

# write to png device
png(file="plot3.png",width=480,height=480)
par(mar=c(4,4,3,2), bg=NA)
plot.ts(hpc_sm1, xaxt = "n", yaxt = "n", xlab="", ylab="", ylim=range(c(hpc_sm1,hpc_sm2,hpc_sm3)))
par(new = TRUE)
plot.ts(hpc_sm2, xaxt = "n", yaxt = "n", xlab="", ylab="", col="red", ylim=range(c(hpc_sm1,hpc_sm2,hpc_sm3)))
par(new = TRUE)
plot.ts(hpc_sm3, xaxt = "n", yaxt = "n", xlab="", ylab="", col="blue", ylim=range(c(hpc_sm1,hpc_sm2,hpc_sm3)))

title( ylab="Energy sub metering")
axis(side=1, at=c(0,480,960), labels=c("Thu","Fri","Sat"))
axis(side=2, at=c(0,10,20,30))
legend("topright", c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), lty=1, col = c("black","red","blue"))

#dev.copy(png, file="plot3.png")
dev.off()
