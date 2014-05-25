rankall <- function(outcome, num = "best") {
        ## Read outcome data
        data <- read.csv("outcome-of-care-measures.csv", colClasses = "character")
        
        ## Check that state and outcome are valid
        validOutcome <- outcome %in% c("heart attack", "heart failure", "pneumonia")
        
        if (validOutcome == FALSE) {
                stop("invalid outcome")
        }
        
        if (num != "best" && num != "worst") {
                num <- as.numeric(num)
        }
        
        ## For each state, find the hospital of the given rank
        state <- unique(data[,7])
        state <- sort(state)
        hospital <- c()
        data[, 11] <- suppressWarnings(as.numeric(data[, 11]))
        data[, 17] <- suppressWarnings(as.numeric(data[, 17]))
        data[, 23] <- suppressWarnings(as.numeric(data[, 23]))
        
        for (i in 1:length(state)) {
                data2 <- subset(data, data$State == state[i])
                data2 <- data2[order(data2$Hospital.Name),]
                
                if (outcome == "heart attack") {
                        data2 <- data2[order(data2$Hospital.30.Day.Death..Mortality..Rates.from.Heart.Attack, na.last = NA),]
                } else if (outcome == "heart failure") {
                        data2 <- data2[order(data2$Hospital.30.Day.Death..Mortality..Rates.from.Heart.Failure, na.last = NA),]
                } else if (outcome == "pneumonia") {
                        data2 <- data2[order(data2$Hospital.30.Day.Death..Mortality..Rates.from.Pneumonia, na.last = NA),]
                }
                
                if (num == "worst"){
                        hospital[i] <- tail(data2[,2], n=1)
                } else if (num == "best") {
                        hospital[i] <- data2[1, 2]
                } else if (num > length(data2[,2])) { 
                        hospital[i] <- NA
                } else {
                        hospital[i] <- data2[num, 2]
                }
                
        }
        
        ## Return a data frame with the hospital names and the
        
        ## (abbreviated) state name
        return(data.frame(hospital, state))
}