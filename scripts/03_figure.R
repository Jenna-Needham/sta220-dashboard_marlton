################################################################################
############              FIGURE 1: SCHOOL PERFORMANCE                 ########
################################################################################

# Packages and Load the Data ---------------------------------------------------

library(tidyverse)

schools_merged <- read_csv("data/schools_merged.csv")
schools_merged <- read_csv("app/data/schools_merged.csv")

# Check data
dim(schools_merged)
names(schools_merged)
summary(schools_merged)


# Prepare the Data ------------------------------------------------------------

schools_long <- schools_merged |>
  pivot_longer(
    cols = c(ela_proficient, math_proficient),
    names_to = "subject",
    values_to = "proficiency"
  ) |>
  mutate(
    subject = ifelse(subject == "ela_proficient", "ELA", "Math"),
    proficiency = as.numeric(proficiency),
    school_name = str_remove(school_name, " Elementary School")
  )

# Check data
dim(schools_long)
names(schools_long)
summary(schools_long)


# All Grades --------------------------------------------------------------
schools_long_math <- schools_long |>
  filter(subject == "Math")

fig1 <- ggplot(
  schools_long_math,
  aes(x = school_name, y = proficiency, fill = grade_test)
) +
  geom_col() +
  labs(
    title = "Grade 3 ELA and Math Proficiency Across Evesham Schools",
    x = "Elementary School",
    y = "Proficiency (%)"
  )

fig1


################################################################################
############                       GRADE 3                            #########
################################################################################

grade3 <- schools_long |>
  filter(grade_test == "Grade 3")

write_csv(
  grade3,
  "app/data/grade3.csv"
)

fig1 <- ggplot(
  grade3,
  aes(x = school_name, y = proficiency, fill = subject)
) +
  geom_col(position = "stack") +
  labs(
    title = "Grade 3 ELA and Math Proficiency Across Evesham Schools",
    x = "Elementary School",
    y = "Proficiency (%)",
    fill = "Subject"
  )

fig1


################################################################################
############                       GRADE 4                            #########
################################################################################

grade4 <- schools_long |>
  filter(grade_test == "Grade 4")

fig2 <- ggplot(
  grade4,
  aes(x = school_name, y = proficiency, fill = subject)
) +
  geom_col(position = "stack") +
  labs(
    title = "Grade 4 ELA and Math Proficiency Across Evesham Schools",
    x = "Elementary School",
    y = "Proficiency (%)",
    fill = "Subject"
  )

fig2



################################################################################
############                       GRADE 5                            #########
################################################################################

grade5 <- schools_long |>
  filter(grade_test == "Grade 5")

fig3 <- ggplot(
  grade5,
  aes(x = school_name, y = proficiency, fill = subject)
) +
  geom_col(position = "stack") +
  labs(
    title = "Grade 5 ELA and Math Proficiency Across Evesham Schools",
    x = "Elementary School",
    y = "Proficiency (%)",
    fill = "Subject"
  )

fig3


################################################################################
############            FIGURE 2: STUDENT GROWTH                            #########
################################################################################

# Packages and Load the Data ---------------------------------------------------

library(tidyverse)

growth_clean <- read_csv("data/growth_clean.csv")

# Check data
dim(growth_clean)
names(growth_clean)
summary(growth_clean)

# Prepare the Data ------------------------------------------------------------

growth_long <- growth_clean |>
  pivot_longer(
    cols = c(
      ela_median_student_growth_percentile_school,
      math_median_student_growth_percentile_school
    ),
    names_to = "subject", 
    values_to = "growth"
  ) |>
  mutate(
    subject = ifelse(
      subject == "ela_median_student_growth_percentile_school", "ELA", "Math"
    ),
    school_name = str_remove(
      school_name, 
      "Elementary School"
    )
  )

# Check data
dim(growth_long)
names(growth_long)
summary(growth_long)

# Create Figure 2 
fig4 <- ggplot(
  growth_long, 
  aes(x = school_name, y = growth, fill = subject)
) + 
  geom_col(position = "dodge") +
  labs(
    title = "Median Student Growth Across Evesham Schools", 
    x = "Elementary School",
    y = "Median Student Growth Percentile",
    fill = "Subject"
  )

fig4

################################################################################
############                       SAVE FIGURES                        #########
################################################################################

ggsave("grade3_performance.png", fig1)

ggsave("grade4_performance.png", fig2)

ggsave("grade5_performance.png", fig3)

ggsave("student_growth.png", fig4)
