
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

# try using dplyr to add column date_time and graph that vs Global_active_power
hpc_timestamp <- within(hpc_df_days, { timestamp=format(as.POSIXct(paste(Date, Time)), "%Y-%m-%d %H:%M:%S") })

# write to png device
png(file="plot4.png",width=480,height=480)

# set up for 2X2 plots
par(mfrow=c(2,2), bg=NA, mar=c(4.5,4,3,2))

# plot 1 - Global Active Power
#par(mar=c(4,4,3,2), bg=NA)
hpc_ts <- ts(hpc_timestamp$Global_active_power, frequency=3, start=c(1,1))

plot.ts(hpc_ts, xaxt = "n", yaxt = "n", xlab="", ylab="")

title(ylab="Global Active Power")
axis(side=1, at=c(0,480,960), labels=c("Thu","Fri","Sat"))
axis(side=2, at=c(0,2,4,6))

# voltage plot
plot.ts(hpc_timestamp$Voltage, xaxt = "n", yaxt = "n", xlab="", ylab="")
hpc.xrange <- length(hpc_timestamp$timestamp)
title(xlab="datetime", ylab="Voltage")
axis(side=1, at=c(0,hpc.xrange/2,hpc.xrange), labels=c("Thu","Fri","Sat"))
axis(side=2,  at=c(234, 236, 238, 240, 242, 244, 246), labels=c("234","","238","","242","","246"))

#plot 3 below

hpc_sm1 <- ts(hpc_timestamp$Sub_metering_1, frequency=3, start=c(1,1))
hpc_sm2 <- ts(hpc_timestamp$Sub_metering_2, frequency=3, start=c(1,1))
hpc_sm3 <- ts(hpc_timestamp$Sub_metering_3, frequency=3, start=c(1,1))

par(mar=c(5,5,3,2), bg=NA)
plot.ts(hpc_sm1, xaxt = "n", yaxt = "n", xlab="", ylab="", ylim=range(c(hpc_sm1,hpc_sm2,hpc_sm3)))
par(new = TRUE)
plot.ts(hpc_sm2, xaxt = "n", yaxt = "n", xlab="", ylab="", col="red", ylim=range(c(hpc_sm1,hpc_sm2,hpc_sm3)))

par(new = TRUE)
plot.ts(hpc_sm3, xaxt = "n", yaxt = "n", xlab="", ylab="", col="blue", ylim=range(c(hpc_sm1,hpc_sm2,hpc_sm3)))

title( ylab="Energy sub metering")
axis(side=1, at=c(0,480,960), labels=c("Thu","Fri","Sat"))
axis(side=2, at=c(0,10,20,30))
legend("topright", c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), inset=0.05, lty=1, col = c("black","red","blue"), cex=0.75, bty="n")


# global reactive power plot
#par(mfrow=c(2,2))
plot.ts(hpc_timestamp$Global_reactive_power, xaxt = "n", yaxt = "n", xlab="", ylab="")
hpc.xrange <- length(hpc_timestamp$timestamp)
title(xlab="datetime", ylab="Global_reactive_power")
axis(side=1, at=c(0,hpc.xrange/2,hpc.xrange), labels=c("Thu","Fri","Sat"))
axis(side=2,  at=c(0.0,0.1,0.2,0.3,0.4,0.5))

#dev.copy(png, file="plot4.png")
dev.off()
