# ---- 1. Read data ----

library(dplyr)

# Cleaning enviromental from empty rows and columns
env <- read.csv("Data/environmentaldata.csv", header = TRUE) %>%
  mutate(across(where(is.character), ~ na_if(trimws(.), ""))) %>%
  select(where(~ any(!is.na(.)))) %>%
  filter(if_any(everything(), ~ !is.na(.)))
dim(env)
which(rowSums(!is.na(env)) == 0)
which(colSums(!is.na(env)) == 0)

# cleaning vasplants from empty rows and columns
readr::guess_encoding("Data/speciesdata.csv")
vas.plants <- read.csv(
  "Data/speciesdata.csv",
  header = F,
  sep = ",",
  fileEncoding = "ISO-8859-1"
) %>%
  mutate(across(where(is.character), ~ na_if(trimws(.), ""))) %>%
  select(where(~ any(!is.na(.)))) %>%
  filter(if_any(everything(), ~ !is.na(.)))

dim(vas.plants)
summary(vas.plants)
any(is.na(vas.plants))
which(rowSums(!is.na(vas.plants)) == 0)
which(colSums(!is.na(vas.plants)) == 0)


# ---- 3. Simple map with sample points ----

library(ggplot2)
install.packages("sf") # for countries map, ne_countries
install.packages("rnaturalearth") # state borders
library(rnaturalearth)
install.packages("rnaturalearthdata") # metadata
library(rnaturalearthdata)

europe <- ne_countries(continent = "Europe", returnclass = "sf")

ggplot() +
  geom_sf(data = europe, fill = "grey80", color = "white") +
  geom_point(
    data = env,
    aes(x = Latitude, y = Longitude),
    color = "red",
    size = 1,
    alpha = 0.8,
    inherit.aes = FALSE
  ) +
  coord_sf(xlim = c(-15, 20), ylim = c(40, 70), expand = FALSE) +
  theme_minimal() +
  labs(
    title = "Sampling sites",
    x = "Longitude (°E)",
    y = "Latitude (°N)"
  )
