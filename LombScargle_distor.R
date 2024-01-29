library(data.table)
library(lomb)

library(survival)
library(grid)
library(gridGraphics)

myData = fread(choose.files(multi = FALSE))

times = myData$V1
measurements = myData$V3

lombResult = lsp(measurements, times = times, from = 5, to = 25, type = "period", ofac = 100)

peakPeriodicity = lombResult$peak.at[1]
peakPeriodicityPower = lombResult$peak

noiseBooleanVector = (lombResult$scanned < peakPeriodicity - 0.5
                      | lombResult$scanned > peakPeriodicity + 0.5)
SNR = peakPeriodicityPower / median(lombResult$power[noiseBooleanVector])

outputTable = data.frame(Scanned = lombResult$scanned, Power = lombResult$power)
write.table(outputTable, file = "lomb_output.tsv", sep = '\t', row.names = FALSE)