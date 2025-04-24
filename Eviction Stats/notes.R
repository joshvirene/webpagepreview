# notes: 


# prototype; done for one year of data- 2018

# Import all datasets: 
tenure_2018 <- read_excel("ACS Data/Web_ACS2018_Housing.xlsx", sheet = "Tenure", skip = 4)
rentvalue_2018 <- read_excel("ACS Data/Web_ACS2018_Housing.xlsx", sheet = "Renter Costs", skip = 4)

# Clean the data, using janitor
tenure_2018 <- tenure_2018 %>% clean_names()
rentvalue_2018 <- rentvalue_2018 %>% clean_names()

# Tenure; the entire process to be done for each year is as follows
tenure_2018 <- read_excel("2018-2023 ACS Data/Web_ACS2018_Housing.xlsx", sheet = "Tenure", skip = 4)
tenure_2018 <- tenure_2018 %>% clean_names()
tenure_2018 <- tenure_2018 %>% 
  filter(geography %in% counties_of_interest)



tenure_2018 <- tenure_2018 %>% 
  filter(geography %in% counties_of_interest)

rentvalue_2018 <- rentvalue_2018 %>% 
  filter(geography %in% counties_of_interest)

Web_ACS2018_Housing <- read_excel("ACS Data/Web_ACS2018_Housing.xlsx")


# preliminary plots; I didn't like these too much:





# Rent price (careful, this is not normalized by a price index)
# ggplot(data = renterscost_sac, aes(x = year, y = gross_rent_median_dollars_estimate)) +
#   geom_point(size = 2, alpha = 0.7) +
#   geom_errorbar(aes(ymin = gross_rent_lower, ymax = gross_rent_upper), width = 0.2) + 
#   labs(title = "Median Rent Price in Sacramento County",
#        x = "Year",
#        y = "Gross Median Rent ($)",
#        caption = "Source: ACS Data") +
#   theme_minimal() +
#   theme(plot.title = element_text(face = "bold", size = 18),
#         axis.text.x = element_text(angle = 45, hjust = 1),
#         legend.position = "right")


