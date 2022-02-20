# read in data
gold <- read.csv("gold_raw.csv")
# for (i in 1:length(gold$Value)){
#   if (is.nan(gold[i,2])){
#     gold[i,2] = NA
#   }
# }

# load package
pacman::p_load(tidyverse)

# define zero matrices
exp_value <- matrix(0, nrow = length(gold$Value), ncol = 1)

sd <- matrix(0, nrow = length(gold$Value), ncol = 1)

# finding running mean and standard deviation
for (i in 1:length(gold$Value)){
  
  run <- gold[1:i,2]
  
  exp_value [i,1] <- mean(run, na.rm = TRUE)
  
  sd[i,1] <- sd(run, na.rm = TRUE)
  
  
}

# combine mean and standard deviation to original data
gold <- data.frame(gold, exp_value, sd)





# read in data
bitcoin <- read.csv("bitcoin.csv")
# for (i in 1:length(bitcoin$Value)){
#   if (is.nan(bitcoin[i,2])){
#     bitcoin[i,2] = NA
#   }
# }

# load package
pacman::p_load(tidyverse)

# define zero matrices
exp_value <- matrix(0, nrow = length(bitcoin$Value), ncol = 1)

sd <- matrix(0, nrow = length(bitcoin$Value), ncol = 1)

# finding running mean and standard deviation
for (i in 1:length(bitcoin$Value)){
  
  run <- bitcoin[1:i,2]
  
  exp_value [i,1] <- mean(run, na.rm = TRUE)
  
  sd[i,1] <- sd(run, na.rm = TRUE)
  
  
}

# combine mean and standard deviation to original data
bitcoin <- data.frame(bitcoin, exp_value, sd)




# Brownian Motion ---------------------------------------------------------

# define zero matrices
exp_perc_change <- matrix(0, nrow = length(gold$Value), ncol = 1)
diff <- matrix(0, nrow = length(gold$Value), ncol = 1)
perc_diff <- matrix(0, nrow = length(gold$Value), ncol = 1)

for (i in 3:length(gold$Value)-1){
  if (!is.nan(gold[i,2])){
    x<- gold[i,2]
  }
  if (!is.nan(gold[i+1,2])){
    diff[i+1] <- (gold[i+1,2] - x)
    perc_diff[i+1] <- (gold[i+1,2]-x)/x
  }
}

gold <- data.frame(gold, diff, perc_diff)

for (i in 1:length(gold$diff)){
    if (gold[i,5] == 0){
       gold[i,5] = NA
     }
   }


# define zero matrices
exp_perc_change <- matrix(0, nrow = length(gold$Value), ncol = 1)
sd_perc_change <- matrix(0, nrow = length(gold$Value), ncol = 1)

exp_diff_change <- matrix(0, nrow = length(gold$Value), ncol = 1)
sd_diff_change <- matrix(0, nrow = length(gold$Value), ncol = 1)

for (i in 1:length(gold$Value)){
  
  run <- gold[1:i,5]
  
  runa <- gold[1:i,6]
  
  exp_perc_change [i,1] <- mean(runa, na.rm = TRUE)
  
  sd_perc_change[i,1] <- sd(runa, na.rm = TRUE)
  
  exp_diff_change [i,1] <- mean(run, na.rm = TRUE)
  
  sd_diff_change[i,1] <- sd(run, na.rm = TRUE)
  
}

gold <- data.frame(gold, exp_perc_change, sd_perc_change, exp_diff_change, sd_diff_change)


gbm_loop <- function(nsim = 100, t = 25, mu = 0, sigma = 0.1, S0 = 100, dt = 1./252) {
  gbm <- matrix(ncol = nsim, nrow = t)
  for (simu in 1:nsim) {
    gbm[1, simu] <- S0
    for (day in 2:t) {
      epsilon <- rnorm(1)
      dt = 1 / 365
      gbm[day, simu] <- gbm[(day-1), simu] * exp((mu - sigma * sigma / 2) * dt + sigma * epsilon * sqrt(dt))
    }
  }
  return(gbm)
}

library(tidyverse)
nsim <- 1
t <- 30
mu <- (gold[30,7] +1)^252-1
sigma <- gold[30,8] * sqrt(252)
S0 <- gold[30,2]
gbm <- gbm_loop(nsim, t, mu, sigma, S0)

# PLOT GBM vs ACTUAL VALUES
gbm_df <- as.data.frame(gbm) %>%
  mutate(day = 1:nrow(gbm) + 30) %>%
  pivot_longer(-day, names_to = 'sim', values_to = 'predicted')
gbm_df <- data.frame(gbm_df, actual=gold$Value[30:59])
gbm_df <- gbm_df %>% 
  select(day, predicted, actual) %>%
  gather(key = "variable", value = "value", -day)
ggplot(gbm_df, aes(x = day, y = value)) + 
  geom_line(aes(color = variable, linetype = variable)) + 
  scale_color_manual(values = c("darkred", "steelblue"))+
  theme(plot.title = element_text(size=12, face="bold", 
                                  margin = margin(10, 0, 10, 0))) +
  ggtitle("Brownian Motion Model for Gold Price for 30 days using previous 30 day data")
  
# gbm_df %>%
#   ggplot(aes(x=ix)) +
#   geom_line(aes(y =price) , color = 'red') +
#   geom_line(aes(y =actual), color = 'blue') +
#   theme(legend.position = 'left')



# plot(gbm_df$ix, gbm_df$price, type = 'l', col = 'red')
# lines(df$x, df$y, col = "blue")


# for (i in 1:length(gold$Value)){
#      if (is.nan(gold[i,2])){
#        gold[i,2] = NA
#      }
#    }
#   
# df <- data.frame(x=0:30, y=gold$Value[30:60])
# 
# df %>% ggplot(aes(x, y)) + geom_line()



