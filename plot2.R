
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

# create timeseries object for plotting
hpc_ts <- ts(hpc_timestamp$Global_active_power, frequency=3, start=c(1,1))

# write to png device
png(file="plot2.png",width=480,height=480)

par(mar=c(4,4,3,2), bg=NA)
plot.ts(hpc_ts, xaxt = "n", yaxt = "n", xlab="", ylab="Global Active Power (kilowatts)")

axis(side=1, at=c(0,480,960), labels=c("Thu","Fri","Sat"))
axis(side=2, at=c(0,2,4,6))

#dev.copy(png, file="plot2.png")
dev.off()
