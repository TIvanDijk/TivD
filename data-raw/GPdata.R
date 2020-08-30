## code to prepare `GPdata` dataset goes here
library(readxl)
library(dplyr)
library(sf)

mun.borders <- st_read("https://geodata.nationaalgeoregister.nl/cbsgebiedsindelingen/wfs?request=GetFeature&service=WFS&version=2.0.0&typeName=cbs_gemeente_2020_gegeneraliseerd&outputFormat=json",
                       quiet = TRUE)[, c('statnaam', 'geometry')]

mun.middle <- st_read("https://geodata.nationaalgeoregister.nl/cbsgebiedsindelingen/wfs?request=GetFeature&service=WFS&version=2.0.0&typeName=cbs_gemeente_2020_labelpoint&outputFormat=json",
        quiet = TRUE)[-356, c('statnaam', 'geometry')]
names(mun.middle)[2] <- "mid.geom"

prov.borders <- st_read("https://geodata.nationaalgeoregister.nl/cbsgebiedsindelingen/wfs?request=GetFeature&service=WFS&version=2.0.0&typeName=cbs_provincie_2020_gegeneraliseerd&outputFormat=json",
                        quiet = TRUE)[, c('statnaam', 'geometry')]
names(prov.borders)[2] <- 'prov.gem'

mun.per.prov <- read_excel("data-raw/GPdata.xlsx") %>%
  select(statnaam = Gemeentenaam, prov = Provincienaam)

GPdata <- left_join(mun.per.prov, mun.borders) %>%
  left_join(mun.middle) %>%
  left_join(prov.borders, by = c('prov' = 'statnaam'))
names(GPdata) <- c('gem', 'prov', 'gem.geometry', 'gem.geometry.midpoint', 'prov.geometry')
View(GPdata)
usethis::use_data(GPdata, overwrite = T)

