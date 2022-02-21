pacman::p_load(tidyverse)

bitcoin <- read.csv("bitcoin_path.csv")

bitcoin_weekly <- read.csv("bitcoin_path_weekly.csv")

for (i in 1:length(bitcoin_weekly$present_day)){
  
  if (bitcoin_weekly[i,3] > 1000000000){
    bitcoin_weekly[i,3] <- NA
  }else if (is.infinite(bitcoin_weekly[i,3])){
    bitcoin_weekly[i,3] <- NA
  }
  
}

plot(bitcoin_weekly$future_day, bitcoin_weekly$final_price, type='l', col = 'red')


gold <- read.csv("gold_path.csv")
gold_og <- read.csv("gold_raw.csv")
gold_og <- na.omit(gold_og)

plot(gold$future_day, gold$final_price, type = 'l', col = 'red')
  lines(1:1255, gold_og$Value, col = "blue")
