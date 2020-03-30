## code to prepare `GPdata` dataset goes here
library(readxl)
library(dplyr)
library(sf)

mun.borders <- st_read("https://geodata.nationaalgeoregister.nl/cbsgebiedsindelingen/wfs?request=GetFeature&service=WFS&version=2.0.0&typeName=cbs_gemeente_2020_gegeneraliseerd&outputFormat=json",
                       quiet = TRUE)[, c('statnaam', 'geometry')]

mun.per.prov <- read_excel("data-raw/GPdata.xlsx") %>%
  select(statnaam = Gemeentenaam, prov = Provincienaam)

GPdata <- left_join(mun.per.prov, mun.borders)
names(GPdata) <- c('gem', 'prov', 'gem.geometry')

usethis::use_data(GPdata, overwrite = T)
