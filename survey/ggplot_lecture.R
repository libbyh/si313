### Interactive Lecture: GGPlot Tips and Tricks 

# Install Libraries 
# install.packages("ggplot2")
# install.packages("dplyr")
# install.packages("patchwork")
 
# Load Library 
library(ggplot2)
library(dplyr)
library(patchwork)

# Path Management 
getwd()
data_dir <- "/your/data/path/here"
output_dir <- "/your/output/path/here"
setwd(data_dir)
list.files()

# Load Data 
survey <- read.csv("survey_results_public.csv")

# Sampling 
set.seed(123) # Why do we set seeds? 
sampled_survey <- survey[sample(nrow(survey), 1000), ]

# Let's graph the number of years spent coding! 
sampled_survey$YearsCode # Why inspect the data? 

# Drop Missings 
sampled_survey <- sampled_survey[!is.na(sampled_survey$YearsCode),]
sampled_survey$YearsCode

### Single Variable Anlaysis: Histogram ### 
# Histogram of YearsCode
ggplot(sampled_survey, aes(x = YearsCode)) + 
  geom_histogram()
      
# Specifying Binwidth 
ggplot(sampled_survey, aes(x = YearsCode)) + 
  geom_histogram(binwidth = 1)

# Adding Color 
kblue <<- "#34628D"
ggplot(sampled_survey, aes(x = YearsCode)) +
  geom_histogram(binwidth = 1, fill = kblue, color = kblue)

### Two Variable Anlaysis ### 
# Inspect Data 
sampled_survey$Industry
table(sampled_survey$Industry)

# Drop Missings 
sampled_survey <- sampled_survey[!is.na(sampled_survey$Industry),]

# Collapse 
industry_summary <- sampled_survey %>%
  group_by(Industry) %>%
  summarise(
    mean_years = mean(YearsCode, na.rm = TRUE),
    se_years   = sd(YearsCode, na.rm = TRUE) / sqrt(n())
  )

# Basic Points 
ggplot(industry_summary, aes(x = Industry, y = mean_years)) +
  geom_point(size = 3, color = kblue) 

# Create Order 
ggplot(industry_summary, aes(x = reorder(Industry, mean_years), y = mean_years)) +
  geom_point(size = 3, color = kblue) 

# Flip Coordinates 
ggplot(industry_summary, aes(x = reorder(Industry, mean_years), y = mean_years)) +
  geom_point(size = 3, color = kblue) + 
  coord_flip()

# Fix Labels 
ggplot(industry_summary, aes(x = reorder(Industry, mean_years), y = mean_years)) +
  geom_point(size = 3, color = kblue) + 
  coord_flip() +
  labs(x = "Industry", y = "Average Years of Coding")

# Add Error Bars 
ggplot(industry_summary, aes(x = reorder(Industry, mean_years), y = mean_years)) +
  geom_point(size = 3, color = kblue) +
  geom_errorbar(aes(ymin = mean_years - 1.96 * se_years,
                    ymax = mean_years + 1.96 * se_years),
                width = 0.2, color = kblue) +
  coord_flip() +
  labs(x = "Industry", y = "Average Years of Coding")

# Add Error Bars 
ggplot(industry_summary, aes(x = reorder(Industry, mean_years), y = mean_years)) +
  geom_point(size = 3, color = kblue) +
  geom_errorbar(aes(ymin = mean_years - 1.96 * se_years,
                    ymax = mean_years + 1.96 * se_years),
                width = 0.2, color = kblue) +
  coord_flip() +
  labs(x = "Industry", y = "Average Years of Coding")

# Add Theme 
ggplot(industry_summary, aes(x = reorder(Industry, mean_years), y = mean_years)) +
  geom_point(size = 3, color = kblue) +
  geom_errorbar(aes(ymin = mean_years - 1.96 * se_years,
                    ymax = mean_years + 1.96 * se_years),
                width = 0.2, color = kblue) +
  coord_flip() +
  labs(x = "Industry", y = "Average Years of Coding") + 
  theme_minimal()

# Include 0 for Accurate Visualization  
ggplot(industry_summary, aes(x = reorder(Industry, mean_years), y = mean_years)) +
  geom_point(size = 3, color = kblue) +
  geom_errorbar(aes(ymin = mean_years - 1.96 * se_years,
                    ymax = mean_years + 1.96 * se_years),
                width = 0.2, color = kblue) +
  coord_flip() +
  labs(x = "Industry", y = "Average Years of Coding") + 
  theme_minimal() + 
  expand_limits(y = 0)
  
# Change to Bars 
ggplot(industry_summary, aes(x = reorder(Industry, mean_years), y = mean_years)) +
  geom_col(fill = kblue, alpha = 0.8) +
  geom_errorbar(aes(ymin = mean_years - 1.96 * se_years,
                    ymax = mean_years + 1.96 * se_years),
                width = 0.3, color = "black") +
  coord_flip() +
  labs(x = "Industry", y = "Average Years of Coding") + 
  theme_minimal(base_size = 14)

# Save Plots to Object 
g1 <- ggplot(industry_summary, aes(x = reorder(Industry, mean_years), y = mean_years)) +
  geom_point(size = 3, color = kblue) +
  geom_errorbar(aes(ymin = mean_years - 1.96 * se_years,
                    ymax = mean_years + 1.96 * se_years),
                width = 0.2, color = kblue) +
  coord_flip() +
  labs(x = "Industry", y = "Average Years of Coding") + 
  theme_minimal() + 
  expand_limits(y = 0)

g1 

g2 <- ggplot(industry_summary, aes(x = reorder(Industry, mean_years), y = mean_years)) +
  geom_col(fill = kblue, alpha = 0.8) +
  geom_errorbar(aes(ymin = mean_years - 1.96 * se_years,
                    ymax = mean_years + 1.96 * se_years),
                width = 0.3, color = "black") +
  coord_flip() +
  labs(x = "Industry", y = "Average Years of Coding") + 
  theme_minimal(base_size = 14)

g1 
g2

# Use Patchwork to Create Complex Figures  
g <- g1 / g2
g

# Save Output  
setwd(output_dir)
ggsave("combined_plot.png", g, width = 8, height = 6, dpi = 300)

