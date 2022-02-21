#Load data
bitcoin <- read.csv("bitcoin.csv")
source("Brownian_Motion_Function.R")

# Call Data Handling Function ------------------------------------------------------

summary <- summary_data(bitcoin)

# Call Price Predictions GBM Function --------------------------------------------------

gbm_df <- gbm_price_pred(summary, 1, 30, summary$exp_perc_change[30], summary$sd_perc_change[30], summary$Value[30], 365, 30)


# Graph Data --------------------------------------------------------------

ggplot(gbm_df, aes(x = day, y = value)) + 
  geom_line(aes(color = variable, linetype = variable)) + 
  scale_color_manual(values = c("darkred", "steelblue"))+
  theme(plot.title = element_text(size=12, face="bold", 
                                  margin = margin(10, 0, 10, 0))) +
  ggtitle("Brownian Motion Model for Gold Price for 30 days using previous 30 day data")

