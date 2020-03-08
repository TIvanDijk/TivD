## code to prepare `GPdata` dataset goes here
library(readxl)
library(dplyr)

GPdata <- read_excel("data-raw/GPdata.xlsx") %>%
  select(gem = Gemeentenaam, prov = Provincienaam)

usethis::use_data(GPdata, overwrite = T)
