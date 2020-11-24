#key only API
library(httr)
library(rvest)
library(tidyverse)

url <- "https://geiselmed.dartmouth.edu/qbs/2019-cohort/"
webpage <- read_html(url)
text <- webpage %>% html_nodes("div") %>% html_text()
masters_2019 <- text[17]

library(rnoaa)
options(noaakey = 'UgkXFTDmAhFgUhBUKKFRJjCfrCDWKwVx')

out <- ghcnd(stationid='USW00013840', refresh = TRUE)

out <- out %>%
  filter(element %in% c('TMAX', 'TMIN')) %>%
  na.omit()

out %>%
  group_by(element) %>%
  summarise(min(VALUE1)/10, max(VALUE1)/10)