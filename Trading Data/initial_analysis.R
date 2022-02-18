# read in data
gold <- read.csv("gold.csv")
# for (i in 1:length(gold$Value)){
#   if (is.nan(gold[i,2])){
#     gold[i,2] = NA
#   }
# }

# load package
pacman::p_load(tidyverse)

# define zero matrices
exp_value <- as_tibble(matrix(0, nrow = length(gold$Value), ncol = 1))

sd <- as_tibble(matrix(0, nrow = length(gold$Value), ncol = 1))

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
# for (i in 1:length(gold$Value)){
#   if (is.nan(gold[i,2])){
#     gold[i,2] = NA
#   }
# }

# load package
pacman::p_load(tidyverse)

# define zero matrices
exp_value <- as_tibble(matrix(0, nrow = length(gold$Value), ncol = 1))

sd <- as_tibble(matrix(0, nrow = length(gold$Value), ncol = 1))

# finding running mean and standard deviation
for (i in 1:length(bitcoin$Value)){
  
  run <- bitcoin[1:i,2]
  
  exp_value [i,1] <- mean(run, na.rm = TRUE)
  
  sd[i,1] <- sd(run, na.rm = TRUE)
  
  
}

# combine mean and standard deviation to original data
bitcoin <- data.frame(bitcoin, exp_value, sd)
