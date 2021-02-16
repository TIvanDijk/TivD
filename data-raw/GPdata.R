## code to prepare `GPdata` dataset goes here
library(readxl)
library(dplyr)
library(sf)

mun.borders <- st_read("https://geodata.nationaalgeoregister.nl/cbsgebiedsindelingen/wfs?request=GetFeature&service=WFS&version=2.0.0&typeName=cbs_gemeente_2021_gegeneraliseerd&outputFormat=json",
                       quiet = TRUE)[, c('statnaam', 'geometry')]

mun.middle <- st_read("https://geodata.nationaalgeoregister.nl/cbsgebiedsindelingen/wfs?request=GetFeature&service=WFS&version=2.0.0&typeName=cbs_gemeente_2021_labelpoint&outputFormat=json",
        quiet = TRUE)[-353, c('statnaam', 'geometry')]
names(mun.middle)[2] <- "mid.geom"

prov.borders <- st_read("https://geodata.nationaalgeoregister.nl/cbsgebiedsindelingen/wfs?request=GetFeature&service=WFS&version=2.0.0&typeName=cbs_provincie_2021_gegeneraliseerd&outputFormat=json",
                        quiet = TRUE)[, c('statnaam', 'geometry')]
#prov.borders[2,1] = 'Friesland'

prov.borders.middle <- st_read("https://geodata.nationaalgeoregister.nl/cbsgebiedsindelingen/wfs?request=GetFeature&service=WFS&version=2.0.0&typeName=cbs_provincie_2021_labelpoint&outputFormat=json",
                              quiet = TRUE)[, c('statnaam', 'geometry')]
#prov.borders.middle[2,1] = 'Friesland'

names(prov.borders)[2] <- 'prov.gem'
names(prov.borders.middle)[2] <- 'prov.mid'
mun.per.prov <- read_excel("data-raw/GPdata.xlsx") %>%
  select(statnaam = Gemeentenaam, prov = Provincienaam)

GPdata <- left_join(mun.borders, mun.per.prov) %>%
  left_join(tibble(mun.middle)) %>%
  left_join(tibble(prov.borders), by = c('prov' = 'statnaam')) %>%
  left_join(tibble(prov.borders.middle), by = c('prov' = 'statnaam'))
names(GPdata) <- c('gem', 'prov', 'gem.geometry', 'gem.geometry.midpoint', 'prov.geometry',
                   'prov.geometry.midpoint')
View(GPdata)
GPdata = tibble(GPdata)
usethis::use_data(GPdata, overwrite = T)


