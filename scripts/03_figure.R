################################################################################
############              FIGURE 1: SCHOOL PERFORMANCE                 ########
################################################################################

# Packages and Load the Data ---------------------------------------------------

library(tidyverse)

schools_merged <- read_csv("data/schools_merged.csv")

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


################################################################################
############                       GRADE 3                            #########
################################################################################

grade3 <- schools_long |>
  filter(grade_test == "Grade 3")

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
############                       SAVE FIGURES                        #########
################################################################################

ggsave("grade3_performance.png", fig1)

ggsave("grade4_performance.png", fig2)

ggsave("grade5_performance.png", fig3)
