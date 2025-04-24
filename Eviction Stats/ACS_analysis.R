# Market analysis of ACS data:
# Data source: https://dof.ca.gov/reports/demographic-reports/american-community-survey/#ACS2018x1
# Study period: 2018 - 2023, 2020 excluded, likely due to the COVID pandemic

# Libraries
install.packages("tinytex")
library(pacman)
p_load(tinytex, tidyverse,readxl,janitor,stringr,RColorBrewer)

# Aggregate to county level; 
counties_of_interest <- c("Los Angeles County", "Orange County", "Sacramento County", "San Diego County", "San Francisco County", "Santa Cruz County")


# since we are working over a study period of five years, it is best to automate the process of importing the data

# master datasets: 
datasets <- c(
  "ACS Data/Web_ACS2018_Housing.xlsx",
  "ACS Data/Web_ACS2019_Housing.xlsx",
  "ACS Data/Web_ACS2021_Housing.xlsx",
  "ACS Data/Web_ACS2022_Housing.xlsx",
  "ACS Data/Web_ACS2023_Housing.xlsx"
)

# TENURE SPREADSHEET
# Description: Gives us the number and percentage of renters with margin of error
tenure_list <- list()

for (path in datasets) {
  year <- stringr::str_extract(path, "\\d{4}")
  df <- read_excel(path, sheet = "Tenure", skip = 4) %>%
    clean_names() %>%
    filter(geography %in% counties_of_interest) %>%
    mutate(year = year,
           lower_nCI = renter_occupied_estimate - renter_occupied_margin_of_error,
           upper_nCI = renter_occupied_estimate + renter_occupied_margin_of_error,
           lower_pCI = renter_occupied_percent - renter_occupied_percent_margin_of_error,
           upper_pCI = renter_occupied_percent + renter_occupied_percent_margin_of_error)
  tenure_list[[year]] <- df
}

tenure_all <- bind_rows(tenure_list)

# RENTER COSTS SPREADSHEET
# Description: Gives us the GROSS RENT and GRAPI Data 
rentercost_list <- list()

for (path in datasets) {
  year <- stringr::str_extract(path, "\\d{4}")
  df <- read_excel(path, sheet = "Renter Costs", skip = 4) %>%
    clean_names() %>%
    filter(geography %in% counties_of_interest) %>%
    mutate(year = year,
           across(2:37, ~ as.numeric(.)),
           gross_rent_lower = gross_rent_median_dollars_estimate - gross_rent_median_dollars_margin_of_error,
           gross_rent_upper = gross_rent_median_dollars_estimate + gross_rent_median_dollars_margin_of_error)
  rentercost_list[[year]] <- df
}

rentercosts_all <- bind_rows(rentercost_list)

# Sacramento
tenure_sac <- tenure_all %>% 
  filter(geography == "Sacramento County")

renterscost_sac <- rentercosts_all %>% 
  filter(geography == "Sacramento County")

# Number of renters
Nrenters <- tenure_sac$renter_occupied_estimate

ggplot(data = tenure_sac, aes(x = year, y = Nrenters)) +
  geom_point(size = 2, alpha = 0.7) +
  geom_errorbar(aes(ymin = lower_nCI, ymax = upper_nCI), width = 0.2) + 
  labs(title = "Renting Households over Time in Sacramento",
       x = "Year",
       y = "Number of Renting Households",
       caption = "Source: ACS Data") +
  theme_minimal() +
  theme(plot.title = element_text(face = "bold", size = 18),
        axis.text.x = element_text(angle = 45, hjust = 1),
        legend.position = "right")


# Percentage of renters
Prenters <- tenure_sac$renter_occupied_percent

ggplot(data = tenure_sac, aes(x = year, y = Prenters)) +
  geom_point(size = 2, alpha = 0.7) +
  geom_errorbar(aes(ymin = lower_pCI, ymax = upper_pCI), width = 0.2) + 
  labs(title = "Percentage of Renting Households over Time in Sacramento",
       x = "Year",
       y = "Percentage of Renting Households",
       caption = "Source: ACS Data") +
  theme_minimal() +
  theme(plot.title = element_text(face = "bold", size = 18),
        axis.text.x = element_text(angle = 45, hjust = 1),
        legend.position = "right")


# normalizing rent prices (Chained CPI), using 2021 as a base year
cpi_multipliers <- c(
  "2018" = 0.9498,
  "2019" = 0.9667,
  #"2020" = 0.9837,
  "2021" = 1.0000,
  "2022" = 1.0395,
  "2023" = 1.0757
)

renterscost_sac <- renterscost_sac %>% 
  mutate(adjusted_median_rent = gross_rent_median_dollars_estimate / cpi_multipliers[as.character(year)],
         adjusted_median_rent_moe = gross_rent_median_dollars_margin_of_error / cpi_multipliers[as.character(year)],
         adj_lower = adjusted_median_rent - adjusted_median_rent_moe,
         adj_higher = adjusted_median_rent + adjusted_median_rent_moe)

# Rent Plot
ggplot(data = renterscost_sac, aes(x = year, y = adjusted_median_rent)) +
  geom_point(size = 2, alpha = 0.7) +
  geom_errorbar(aes(ymin = adj_lower, ymax = adj_higher), width = 0.2) + 
  labs(title = "Price Adjusted Median Rent Price in Sacramento County",
       x = "Year",
       y = "Gross Median Rent ($)",
       caption = "Source: ACS Data") +
  theme_minimal() +
  theme(plot.title = element_text(face = "bold", size = 18),
        axis.text.x = element_text(angle = 45, hjust = 1),
        legend.position = "right")


# GRAPHI 
graphi_columns <- c(
  "gross_rent_as_a_percentage_of_household_income_grapi_less_than_15_0_percent_estimate",
  "gross_rent_as_a_percentage_of_household_income_grapi_15_0_to_19_9_percent_estimate",
  "gross_rent_as_a_percentage_of_household_income_grapi_20_0_to_24_9_percent_estimate",
  "gross_rent_as_a_percentage_of_household_income_grapi_25_0_to_29_9_percent_estimate",
  "gross_rent_as_a_percentage_of_household_income_grapi_30_0_to_34_9_percent_estimate",
  "gross_rent_as_a_percentage_of_household_income_grapi_35_0_percent_or_more_estimate",
  "gross_rent_as_a_percentage_of_household_income_grapi_not_computed_estimate"
)

# Rename Columns
renterscost_sac <- renterscost_sac %>% 
  rename(
    GRAPHI_15 = gross_rent_as_a_percentage_of_household_income_grapi_less_than_15_0_percent_estimate,
    GRAPHI_15_19.9 = gross_rent_as_a_percentage_of_household_income_grapi_15_0_to_19_9_percent_estimate,
    GRAPHI_20_24.9 = gross_rent_as_a_percentage_of_household_income_grapi_20_0_to_24_9_percent_estimate,
    GRAPHI_25_29.9 = gross_rent_as_a_percentage_of_household_income_grapi_25_0_to_29_9_percent_estimate,
    GRAPHI_30_34.9 = gross_rent_as_a_percentage_of_household_income_grapi_30_0_to_34_9_percent_estimate,
    GRAPHI_35 = gross_rent_as_a_percentage_of_household_income_grapi_35_0_percent_or_more_estimate,
    GRAPHI_NC = gross_rent_as_a_percentage_of_household_income_grapi_not_computed_estimate
  )

# Because the data is in long format, we can't readily plot this in ggplot. 
renterscost_sac_graphi <- renterscost_sac %>% 
  pivot_longer(cols = starts_with("GRAPHI_"),
               names_to = "GRAPHI_Category",
               values_to = "GRAPHI_Value")
  

# GRAPHI, Final Plot
ggplot(data = renterscost_sac_graphi, aes(x = year, y = GRAPHI_Value, fill = GRAPHI_Category)) +
  geom_col(position = "dodge") +
  scale_fill_brewer(palette = "Blues") +
  labs(title = "Gross Rent as a Percentage of Household Income by Year",
       subtitle = "Sacramento",
       x = "Year",
       y = "Gross Rent as a Percentage of Household Income",
       caption = "Source: https://data-downloads.evictionlab.org/#data-for-analysis/") +
  theme_minimal() +
  theme(plot.title = element_text(face = "bold", size = 18),
        axis.text.x = element_text(angle = 45, hjust = 1),
        legend.position = "right")