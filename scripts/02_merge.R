################################################################################
############                       MERGE DATA                         ##########
################################################################################

# This script will combine the cleaned ELA and Math datasets 

# We will use: 
#   data/ela_clean.csv
#   data/math_clean.csv
#   data/growth_clean.csv

# Our output will be: data/schools_merged.csv

# First run 01_import.R to create the cleaned datasets

# Packages and Load the Data ---------------------------------------------------

library(tidyverse)
library(dplyr)

# Source 1: ELA Performance ----------------------------------------------------

ela <- read_csv(
  "data/ela_clean.csv",
  col_types = cols(school_code = col_character())
)

# One row is one school in one grade. Expect 18 rows.
dim(ela)
names(ela)
summary(ela)

# Source 2: Math Performance ---------------------------------------------------

math <- read_csv(
  "data/math_clean.csv",
  col_types = cols(school_code = col_character())
)

# One row is one school in one grade. Expect 18 rows.
dim(math)
names(math)
summary(math)

# Source 3: Student Growth ----------------------------------------------------

growth <- read_csv(
  "data/growth_clean.csv",
  col_types = cols(school_code = col_character())
)

# One row is one school. Expect 6 rows.
dim(growth)
names(growth)
summary(growth)

# Key ----------------------------------------------------------------

# Expect 0 rows: school_code, school_year, and grade_test should be unique.

ela |>
  count(school_code, school_year, grade_test) |>
  filter(n > 1)

math |>
  count(school_code, school_year, grade_test) |>
  filter(n > 1)
# Can These Be Merged? ----------------------------------------------------------------

# Expect 0 rows: Every ELA record should have a matching Math record

anti_join(
  ela,
  math,
  by = c("school_code", "school_year", "grade_test")
)

# The Merge --------------------------------------------------------------------

# Start with ELA, add Math by school code, year, and grade.

schools_merged <- ela |>
  select(
    school_code,
    school_name,
    school_year,
    grade_test,
    ela_valid_scores = valid_scores_school,
    ela_proficient = proficiency_rate_school,
    ela_state = proficiency_rate_state
  ) |>
  left_join(
    math |>
      select(
        school_code,
        school_year,
        grade_test,
        math_valid_scores = valid_scores_school,
        math_proficient = proficiency_rate_school,
        math_state = proficiency_rate_state
      ),
    by = c("school_code", "school_year", "grade_test")
  )

# Check the Results ------------------------------------------------------------

# Expect 18 rows: six schools across three grades.
dim(schools_merged)
names(schools_merged)
summary(schools_merged)

# Save -------------------------------------------------------------------------

write_csv(
  schools_merged,
  "data/schools_merged.csv"
)
