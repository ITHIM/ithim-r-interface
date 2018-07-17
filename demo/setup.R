rm(list = ls())
pkgs <- c(
  "DT",
  "devtools",
  "shinyjs",
  "tidyverse",  
  "Hmisc",
  "rCharts",
  "shiny",
  "shinythemes",
  "shinyBS",
  "slickR",
  "plotly"
)
# Which packages do we require?
# lapply(pkgs, library, character.only = T)
reqs <- as.numeric(lapply(pkgs, require, character.only = TRUE))

# Committing all the installation packages
# # Install packages we require
# if(sum(!reqs) > 0) install.packages(pkgs[!reqs])
# 
# if(!require(rCharts)) devtools::install_github("rCharts", "ramnathv")
# 
# if(!require(shiny)) devtools::install_github("shiny", "rstudio")

accra_trips <- read_csv("data/accra/baseline_and_three_scenarios.csv")#, header = T, stringsAsFactors = F)

accra_age_cat <- unique(accra_trips$age_cat)
accra_modes <- unique(accra_trips$trip_mode)

accra_modes <- accra_modes[!is.na(accra_modes)]

accra_modes <- subset(accra_modes, !(accra_modes %in% c("Short Walking")))

accra_pa <- read_csv("data/accra/pa/pa_total_mmet_weekly.csv")

accra_ap <- read_csv("data/accra/ap/individual_level_pm_conc_scenarios.csv")

# Add age_cat and sex columns from pa
accra_ap <- left_join(select(accra_pa, participant_id, age_cat, sex), accra_ap)

# Remove participant id and age from the dataset
accra_ap <- select(accra_ap, -c(participant_id))

names(accra_ap)[3:6] <- c("Baseline", "Scenario 1", "Scenario 2", "Scenario 3")

# Remove participant id and age from the dataset
accra_pa <- select(accra_pa, -c(participant_id, age))

names(accra_pa)[3:6] <- c("Baseline", "Scenario 1", "Scenario 2", "Scenario 3")

accra_deaths <- read_csv("data/accra/health/total_deaths.csv")

accra_ylls <- read_csv("data/accra/health/total_ylls.csv")

accra_health_age_cat <- unique(accra_deaths$age.band)

lt <- read_csv("data/accra/health/disease_outcomes_lookup.csv")

accra_msi <- read_csv("data/accra/injuries/mode-specific-injuries.csv")

accra_msi <- reshape2::melt(accra_msi)

accra_msi$Modes <- factor(accra_msi$Modes, levels=unique(accra_msi$Modes))



source("data-processing.R")
# Functions
source("functions.R")