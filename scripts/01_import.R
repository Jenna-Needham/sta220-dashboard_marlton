# IMPORTANT: CENSUS API KEY SETUP 
# This script requires a Census API key to download ACS data. 
#
# Before running this script: 
#
# 1. Obtain a Census API key from https://api.census.gov/data/key_signup.html
# 2. Register the key in R by running the following command in the R console: 
#
# library(tidycensus)
# library(dplyr)
#
# census_api_key("YOUR_API_KEY_HERE")
#
# 3. Restart R
#
# The API key is saved locally on the user's computer. Do not upload or share your API key


# Packages ---------------------------------------------------------------------------------------

# install.packages("tidycensus")
# install.packages("dplyr")

library(tidycensus)
library(dplyr)
library(tidyverse)

# ACS variables to download

acs_variables <- c(
  median_income = "B19013_001", 
  median_home_value = "B25077_001",
  median_rent = "B25064_001"
)

# NEW JERSEY ---------------------------------------------------------------------------------------

acs_nj <- get_acs(
  geography = "state", 
  state = "NJ", 
  variables = acs_variables, 
  year = 2024, 
  survey = "acs5",
  output = "wide"
) %>%
  mutate(Geography = "New Jersey")

# BURLINGTON COUNTY ---------------------------------------------------------------------------------------

acs_burlington <- get_acs(
  geography = "county", 
  state = "NJ", 
  variables = acs_variables, 
  year = 2024, 
  survey = "acs5",
  output = "wide"
) %>%
  filter(GEOID == "34005") %>%
  mutate(Geography = "Burlington County")

# EVESHAM TOWNSHIP ---------------------------------------------------------------------------------------
acs_evesham <- get_acs(
  geography = "county subdivision", 
  state = "NJ", 
  county = "Burlington", 
  variables = acs_variables, 
  year = 2024, 
  survey = "acs5",
  output = "wide"
) %>%
  filter(GEOID == "3400522110") %>%
  mutate(Geography = "Evesham Township")

# MARLTON CDP ---------------------------------------------------------------------------------------
acs_marlton <- get_acs(
  geography = "place", 
  state = "NJ", 
  variables = acs_variables, 
  year = 2024, 
  survey = "acs5",
  output = "wide"
) %>%
  filter(GEOID == "3444100") %>%
  mutate(Geography = "Marlton CDP")

# COMBINE ACS DATA ---------------------------------------------------------------------------------------

acs_comparison <- bind_rows(
  acs_nj,
  acs_burlington,
  acs_evesham,
  acs_marlton
)

# View results
acs_comparison

# SAVE THE DATA ---------------------------------------------------------------------------------------

dir.create(
  "data/processed",
  recursive = TRUE,
  showWarnings = FALSE
)

write.csv(
  acs_comparison,
  "data/processed/ACS_Geographic_Comparison_2024.csv",
  row.names = FALSE
)


# NJDOE Source, ELA Performance ---------------------------------------------------------------------------------------

njdoe_ela <- read_csv(
  "data/njdoe_2024-2025_ela_performance_test.csv"
)

dim(njdoe_ela)
names(njdoe_ela)
summary(njdoe_ela)

# NJDOE Source, Math Performance ---------------------------------------------------------------------------------------

njdoe_math <- read_csv(
  "data/njdoe_2024-2025_math_performance_test.csv"
)

dim(njdoe_math)
names(njdoe_math)
summary(njdoe_math)

# NJDOE Source, Overall Student Growth ---------------------------------------------------------------------------------------
njdoe_student_growth <- read_csv(
  "data/njdoe_2024-2025_student_growth_trends.csv"
)

dim(njdoe_student_growth)
names(njdoe_student_growth)
summary(njdoe_student_growth)
