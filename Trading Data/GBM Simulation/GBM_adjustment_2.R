pacman::p_load(tidyr, tidyverse)

bitcoin <- read.csv("bitcoin.csv")


# Data Handling Function --------------------------------------------------

summary_data <- function(data){
  # input data and remove missing data
  summary <- data
  summary <- na.omit(summary)
  
  # define zero matrices
  exp_price <- matrix(NA, nrow = length(summary$Value), ncol = 1)
  sd <- matrix(NA, nrow = length(summary$Value), ncol = 1)
  
  # finding running mean and standard deviation
  for (i in 1:length(summary$Value)){
    run <- summary[1:i,2]
    exp_price [i,1] <- mean(run, na.rm = TRUE)
    sd[i,1] <- sd(run, na.rm = TRUE)
  }
  # add to data frame
  summary <- data.frame(summary, exp_price, sd)
  
  # define zero matrices
  diff <- matrix(NA, nrow = length(summary$Value), ncol = 1)
  perc_diff <- matrix(NA, nrow = length(summary$Value), ncol = 1)
  
  # calculate differences and percentage differences
  for (i in 2:length(summary$Value)-1){
    if (!is.nan(summary[i,2])){
      x<- summary[i,2]
    }
    if (!is.nan(summary[i+1,2])){
      diff[i+1] <- (summary[i+1,2] - x)
      perc_diff[i+1] <- (summary[i+1,2]-x)/x
    }
  }
  
  # add to data frame
  summary <- data.frame(summary, diff, perc_diff)
  
  # define zero matrices
  exp_perc_change <- matrix(NA, nrow = length(summary$Value), ncol = 1)
  sd_perc_change <- matrix(NA, nrow = length(summary$Value), ncol = 1)
  
  exp_diff_change <- matrix(NA, nrow = length(summary$Value), ncol = 1)
  sd_diff_change <- matrix(NA, nrow = length(summary$Value), ncol = 1)
  
  # calculate summary statistics of differences and percentage differences
  for (i in 2:length(summary$Value)){
    
    run <- summary[1:i,5]
    
    runa <- summary[1:i,6]
    
    exp_perc_change [i,1] <- mean(runa, na.rm = TRUE)
    
    sd_perc_change[i,1] <- sd(runa, na.rm = TRUE)
    
    exp_diff_change [i,1] <- mean(run, na.rm = TRUE)
    
    sd_diff_change[i,1] <- sd(run, na.rm = TRUE)
    
  }
  
  # add to data frame
  summary <- data.frame(summary, exp_perc_change, sd_perc_change, exp_diff_change, sd_diff_change)
  
  
  return(summary)
}



# Call Data Handling Function ------------------------------------------------------


summary <- summary_data(bitcoin)




# Price Predictions GBM -------------------------------------------------------

gbm_price_pred <- function(data, nsim = 100, t = 25, S0 = 100, td = 252, current_day = 10) {
  # adjustment for t ( code functionality )
  t <- t + 1
  
  b <- current_day - t
  if (b<1){
    b = 1
  }
  runa <- data[b:current_day,6]
  
  exp_perc <- mean(runa, na.rm = TRUE)
   
  sd_perc <- sd(runa, na.rm = TRUE)
  # calculate drift
  mu <- (exp_perc +1)^td-1
  # calculate volatility
  sigma <- sd_perc * sqrt(td)
  # define matrix 
  gbm <- matrix(ncol = nsim, nrow = t)
  # reciprocal of the number of trading days
  dt <- 1/td
  # calculate the predicted price for future days
  set.seed(100)
  e_vec <- rnorm(nsim)
  for (i in 1:nsim) {
    gbm[1, i] <- S0
    for (day in 2:t) {
      e <- e_vec[i]
      gbm[day, i] <- gbm[(day-1), i] * exp((mu - sigma * sigma / 2) * dt + sigma * e * sqrt(dt))
    }
  }
  
  gbm_df <- as.data.frame(gbm)
  
  avg <- matrix(0, nrow = dim(gbm_df)[1], ncol = 1)
  
  avg <- data.frame(avg)

  for (i  in 1:dim(gbm_df)[1]){

    run <- gbm_df[i,1:dim(gbm_df)[2]]
    sum <- 0
    for (j in 1:length(run)){
      sum <- sum + run[j]
    }

    avg[i,1] <- sum/length(run)
  }
  
  days <- 1:nrow(gbm) + current_day -1
  gbm_df <- data.frame(days, gbm_df, avg)
  end <- current_day + t - 1
  gbm_df <- data.frame(gbm_df, actual=summary$Value[current_day:end])
  
  # gbm_df <- as.data.frame(gbm) %>%
  #   mutate(day = 1:nrow(gbm) + current_day -1) %>%
  #   pivot_longer(-day, names_to = 'sim', values_to = 'predicted')
  # end <- current_day + t - 1
  # gbm_df <- data.frame(gbm_df, actual=data$Value[current_day:end])
  # gbm_df <- gbm_df %>% 
  #   select(day, predicted, actual) %>%
  #   gather(key = "variable", value = "value", -day)
  
  # returning drift and final price
  drift <- mu
  
  final_price <- gbm_df$avg[dim(gbm_df)[1]]
  
  final_outputs <- data.frame(drift, final_price)
  
  return(final_outputs)
}



# Call Price Predictions GBM Function --------------------------------------------------

gbm_df <- gbm_price_pred(summary, 100, 30, summary$Value[125], 252, 125)

final2 <- gbm_price_pred(summary, 100, 3, summary$Value[3], 252, 3)

for (i in 5:length(summary$Value)-1){
  if (i<30){
    j <- i
  }else if (i>length(summary$Value)-30){
    j<- length(summary$Value)-i
  }else{
    j <- 30
  }
  gbm_df <- gbm_price_pred(summary, 100, j, summary$Value[i], 252, i)
  
  final2 <- rbind(final2, gbm_df)
}

present_day <- days <- 1:dim(final2)[1] + 2
y <- data.frame(present_day, final2)

future_day <- matrix(NA, nrow = dim(final2)[1], ncol = 1)
  
for (i in 4:length(summary$Value)-1){
  if (i<30){
    j <- i
  }else if (i>length(summary$Value)-30){
    j<- length(summary$Value)-i
  }else{
    j <- 30
  }
  
  future_day[i-2,1] <- i+j
}

y <- data.frame(y, future_day)

write.csv(y,"bitcoin_path.csv", row.names = FALSE)

# Graph Data --------------------------------------------------------------

ggplot(gbm_df, aes(x = day, y = value)) + 
  geom_line(aes(color = variable, linetype = variable)) + 
  scale_color_manual(values = c("darkred", "steelblue"))+
  theme(plot.title = element_text(size=12, face="bold", 
                                  margin = margin(10, 0, 10, 0))) +
  ggtitle("Brownian Motion Model for Gold Price for 30 days using previous 30 day data")
