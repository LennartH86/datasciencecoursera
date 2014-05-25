rankhospital <- function(state, outcome, num = "best") {
        ## Read outcome data
        data <- read.csv("outcome-of-care-measures.csv", colClasses = "character")
        
        ## Check that state and outcome are valid
        validState <- data[state %in% data$State]
        validOutcome <- outcome %in% c("heart attack", "heart failure", "pneumonia")
        
        if (ncol(validState) == "0"){
                stop("invalid state")
        }
        if (validOutcome == FALSE) {
                stop("invalid outcome")
        }
        
        if (num != "best" && num != "worst") {
                num <- as.numeric(num)
        }
        
        ## Return hospital name in that state with the given rank
        data2 <- subset(data, data$State == as.character(state))
        data2[, 11] <- suppressWarnings(as.numeric(data2[, 11]))
        data2[, 17] <- suppressWarnings(as.numeric(data2[, 17]))
        data2[, 23] <- suppressWarnings(as.numeric(data2[, 23]))
        data2 <- data2[order(data2$Hospital.Name),]
        
        if (outcome == "heart attack") {
                data2 <- data2[order(data2$Hospital.30.Day.Death..Mortality..Rates.from.Heart.Attack, na.last = NA),]
        } else if (outcome == "heart failure") {
                data2 <- data2[order(data2$Hospital.30.Day.Death..Mortality..Rates.from.Heart.Failure, na.last = NA),]
        } else if (outcome == "pneumonia") {
                data2 <- data2[order(data2$Hospital.30.Day.Death..Mortality..Rates.from.Pneumonia, na.last = NA),]
        }
        
        ## 30-day death rate
        if (num == "worst"){
                return(tail(data2[,2], n=1))
        } else if (num == "best") {
                return(data2[1, 2])
        } else if (num > length(data2[,2])) { 
                return(NA)
        } else {
                return(data2[num, 2])
        }
}