# import the eviction data; source: https://data-downloads.evictionlab.org/#data-for-analysis/
# note that this is the original data, whereas there is also modeled data. That dataset is 
# interpolated in some fashion, so it is not to be used for analysis. 


##################################################################################
#                                                                                #
#                                                                                #
#                         Dataset one: Court Issued Data                         #
#                                                                                #
##################################################################################


# packages:
library(readr)
library(dplyr)
library(tidyverse)
library(readxl)

eviction_data <- read_csv("county_court-issued_2000_2018 (2).csv")

# codes: 
county_court_issued_2000_2018_codebook_1_ <- read_excel("county_court-issued_2000_2018_codebook (1).xlsx")
View(county_court_issued_2000_2018_codebook_1_)

# filtering: 
ca_eviction_data <- eviction_data %>%
  filter(state == "California")

counties_of_interest <- c("Los Angeles County", "Orange County", "Sacramento County", "San Diego County", "San Francisco County", "Santa Cruz County")

ca_eviction_data_filtered <- ca_eviction_data %>% 
  filter(county %in% counties_of_interest)


# now to visualize plots: 


# all counties
# stratified by color
ggplot(data = ca_eviction_data_filtered, aes(x = year, y = filings_observed, color = county)) +
  geom_line(size = 1.2) +
  geom_point(size = 2, alpha = 0.7) +
  labs(title = "Evictions Filings Over Time",
       subtitle = "Selected CA Counties",
       x = "Year",
       y = "Eviction Filings",
       caption = "Source: https://data-downloads.evictionlab.org/#data-for-analysis/") +
  theme_minimal() +
  theme(plot.title = element_text(face = "bold", size = 18),
        axis.text.x = element_text(angle = 45, hjust = 1),
        legend.position = "right")

# facet plot
ggplot(data = ca_eviction_data_filtered, aes(x = year, y = filings_observed)) +
  geom_line(size = 1.2, color = "steelblue") +
  geom_point(size = 2, alpha = 0.7, color = "darkorange") +
  facet_wrap(~ county) +
  labs(title = "Evictions Filings Over Time",
       subtitle = "Selected CA Counties",
       x = "Year",
       y = "Eviction Filings",
       caption = "Source: https://data-downloads.evictionlab.org/#data-for-analysis/") +
  theme_minimal() +
  theme(plot.title = element_text(face = "bold", size = 18),
        axis.text.x = element_text(angle = 45, hjust = 1),
        strip.text = element_text(face = "bold"),
        legend.position = "none")  # legend not needed if county is faceted


# stratified by color
ggplot(data = ca_eviction_data_filtered, aes(x = year, y = renting_hh, color = county)) +
  geom_line(size = 1.2) +
  geom_point(size = 2, alpha = 0.7) +
  labs(title = "Renting Households over Time",
       subtitle = "Selected CA Counties",
       x = "Year",
       y = "Number of Renting Households",
       caption = "Source: https://data-downloads.evictionlab.org/#data-for-analysis/") +
  theme_minimal() +
  theme(plot.title = element_text(face = "bold", size = 18),
        axis.text.x = element_text(angle = 45, hjust = 1),
        legend.position = "right")

# facet plot
ggplot(data = ca_eviction_data_filtered, aes(x = year, y = renting_hh)) +
  geom_line(size = 1.2, color = "steelblue") +
  geom_point(size = 2, alpha = 0.7, color = "darkorange") +
  facet_wrap(~ county) +
  labs(title = "Renting Households over Time",
       subtitle = "Selected CA Counties",
       x = "Year",
       y = "Eviction Filings",
       caption = "Source: https://data-downloads.evictionlab.org/#data-for-analysis/") +
  theme_minimal() +
  theme(plot.title = element_text(face = "bold", size = 18),
        axis.text.x = element_text(angle = 45, hjust = 1),
        strip.text = element_text(face = "bold"),
        legend.position = "none")  # legend not needed if county is faceted


# Sacramento
sacramento <- ca_eviction_data_filtered %>% 
  filter(county == "Sacramento County")


ggplot(data = sacramento, aes(x = year, y = filings_observed)) +
  geom_line(size = 1.2) +
  geom_point(size = 2, alpha = 0.7) +
  labs(title = "Evictions Filings Over Time",
       subtitle = "Selected CA Counties",
       x = "Year",
       y = "Eviction Filings",
       caption = "Source: https://data-downloads.evictionlab.org/#data-for-analysis/") +
  theme_minimal() +
  theme(plot.title = element_text(face = "bold", size = 18),
        axis.text.x = element_text(angle = 45, hjust = 1),
        legend.position = "right")

##################################################################################
#                                                                                #
#                                                                                #
#                         Dataset two: Proprietary Data                          #
#                                                                                #
##################################################################################

eviction_data_proprietary <- read_csv("county_proprietary_valid_2000_2018 (1).csv")


# codes: 
county_proprietary_2000_2018_codebook_1_ <- read_excel("county_proprietary_2000_2018_codebook (1).xlsx")

# filtering: 
eviction_data_proprietary <- eviction_data_proprietary %>%
  filter(state == "California")


# Unfortunately, no proprietary data exists for these counties, so the code below returns a dataset with no observations
# we need to rely on the court data for the stats here. 

counties_of_interest <- c("Los Angeles County", "Orange County", "Sacramento County", "San Diego County", "San Francisco County", "Santa Cruz County")

proprietary_ca_eviction_data_filtered <- eviction_data_proprietary %>% 
  filter(county %in% counties_of_interest)

#######################################################################################
# american community survey











