
gold <- read.csv("gold_raw.csv")



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


summary <- summary_data(gold)




# Price Predictions GBM -------------------------------------------------------

gbm_price_pred <- function(data, nsim = 100, t = 25, exp_perc = 0, sd_perc = 0.1, S0 = 100, td = 252, previous_data = 10) {
  # adjustment for t ( code functionality )
  t <- t + 1
  # calculate drift
  mu <- (exp_perc +1)^td-1
  # calculate volatility
  sigma <- sd_perc * sqrt(td)
  # define matrix 
  gbm <- matrix(ncol = nsim, nrow = t)
  # reciprocal of the number of trading days
  dt <- 1/td
  # calculate the predicted price for future days
  for (i in 1:nsim) {
    gbm[1, i] <- S0
    for (day in 2:t) {
      e <- rnorm(1)
      gbm[day, i] <- gbm[(day-1), i] * exp((mu - sigma * sigma / 2) * dt + sigma * e * sqrt(dt))
    }
  }
  
  # gbm_df <- as.data.frame(gbm)
  # days <- 1:nrow(gbm) + previous_data -1
  # gbm_df <- data.frame(days, gbm_df)
  # end <- previous_data + t - 1
  # gbm_df <- data.frame(gbm_df, actual=summary$Value[previous_data:end])
  # 
  # gbm_df <- gbm_df %>% rename (predicted = V1)
  
  gbm_df <- as.data.frame(gbm) %>%
    mutate(day = 1:nrow(gbm) + previous_data -1) %>%
    pivot_longer(-day, names_to = 'sim', values_to = 'predicted')
  end <- previous_data + t - 1
  gbm_df <- data.frame(gbm_df, actual=summary$Value[previous_data:end])
  gbm_df <- gbm_df %>% 
    select(day, predicted, actual) %>%
    gather(key = "variable", value = "value", -day)
  
  return(gbm_df)
}



# Call Price Predictions GBM Function --------------------------------------------------

gbm_df <- gbm_price_pred(summary, 1, 30, summary$exp_perc_change[30], summary$sd_perc_change[30], summary$Value[30], 252, 30)




# Graph Data --------------------------------------------------------------

ggplot(gbm_df, aes(x = day, y = value)) + 
  geom_line(aes(color = variable, linetype = variable)) + 
  scale_color_manual(values = c("darkred", "steelblue"))+
  theme(plot.title = element_text(size=12, face="bold", 
                                  margin = margin(10, 0, 10, 0))) +
  ggtitle("Brownian Motion Model for Gold Price for 30 days using previous 30 day data")

