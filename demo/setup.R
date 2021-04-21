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

accra_trips <- read_csv("new_accra_results/main_analysis/baseline_and_scenarios.csv")#, header = T, stringsAsFactors = F)
accra_trips$age_cat[accra_trips$age_cat == "50-70"] <- "50-69"

accra_age_cat <- unique(accra_trips$age_cat)
accra_modes <- unique(accra_trips$trip_mode)

accra_modes <- accra_modes[!is.na(accra_modes)]

accra_modes <- subset(accra_modes, !(accra_modes %in% c("Short Walking")))

accra_pa <- read_csv("new_accra_results/main_analysis/pa/pa_total_mmet_weekly.csv")
accra_pa$sex <- gsub("(^|[[:space:]])([[:alpha:]])", "\\1\\U\\2", accra_pa$sex, perl=TRUE)

accra_ap <- read_csv("new_accra_results/main_analysis/ap/individual_level_pm_conc_scenarios.csv")

# Add age_cat and sex columns from pa
accra_ap <- left_join(dplyr::select(accra_pa, participant_id, age_cat, sex), accra_ap)

# Remove participant id and age from the dataset
accra_ap <- dplyr::select(accra_ap, -c(participant_id))

names(accra_ap)[3:ncol(accra_ap)] <- c("Baseline", paste('Scenario', 1:(ncol(accra_ap) - 3), sep = ' '))

# c("Baseline", paste('Scenario', 1:5, sep = ' '))

# Remove participant id and age from the dataset
accra_pa <- dplyr::select(accra_pa, -c(participant_id, age))

names(accra_pa)[3:ncol(accra_pa)] <- c("Baseline", paste('Scenario', 1:(ncol(accra_pa) - 3), sep = ' '))

# c("Baseline", paste('Scenario', 1:5, sep = ' '))

accra_deaths <- read_csv("new_accra_results/main_analysis/health/total_deaths.csv")
accra_deaths$sex <- gsub("(^|[[:space:]])([[:alpha:]])", "\\1\\U\\2", accra_deaths$sex, perl=TRUE)

accra_ylls <- read_csv("new_accra_results/main_analysis/health/total_ylls.csv")
accra_ylls$sex <- gsub("(^|[[:space:]])([[:alpha:]])", "\\1\\U\\2", accra_ylls$sex, perl=TRUE)


# Round health burden to two digits
accra_deaths[, 3:ncol(accra_deaths)] <- round(accra_deaths[, 3:ncol(accra_deaths)], 2)

accra_ylls[, 3:ncol(accra_ylls)] <- round(accra_ylls[, 3:ncol(accra_ylls)], 2)

accra_health_age_cat <- unique(accra_deaths$age_cat)

lt <- read_csv("new_accra_results/main_analysis/health/disease_outcomes_lookup.csv")

# Rename two diseases to remove last spaces
lt$GBD_name[lt$GBD_name == 'Chronic respiratory diseases'] <- 'Chronic respiratory-diseases'
lt$GBD_name[lt$GBD_name == 'Ischemic heart disease'] <- 'Ischemic heart-disease'

# Remove stroke
#lt <- filter(lt, GBD_name != 'Stroke')

accra_msi <- read_csv("new_accra_results/main_analysis/injuries/deaths_by_mode_long.csv")
accra_msi$sex <- gsub("(^|[[:space:]])([[:alpha:]])", "\\1\\U\\2", accra_msi$sex, perl=TRUE)
accra_msi$value <- round(accra_msi$value)


accra_mode_share <- read_csv('new_accra_results/main_analysis/trips/trip_modes_pert.csv')

accra_mode_share <- accra_mode_share %>% mutate(across(where(is.numeric), sprintf, fmt = '%.1f'))

# Add percentage sign
for (i in 2:ncol(accra_mode_share)){
  
  accra_mode_share[[i]] <- paste(accra_mode_share[[i]], '%', sep="")
  
}

names(accra_mode_share)[3:ncol(accra_mode_share)] <- paste('Sc', 1:5)

accra_pm_conc <- read_csv('new_accra_results/main_analysis/ap/conc_pm.csv')
accra_pm_conc <- accra_pm_conc %>% mutate(across(where(is.numeric), sprintf, fmt = '%.1f'))

rownames(accra_pm_conc) <- "background conc."

names(accra_pm_conc) <- c("Baseline", paste('Scenario', (1:(ncol(accra_pm_conc) - 1)), sep = ' '))

accra_health_uncertain <- readr::read_rds("new_accra_results/sensitivity_analysis/sensitivity_analysis_results.Rds")
# 
# evppi <- accra_health_uncertain$uncertain$now$evppi
# 
# parameter_names <- c('walk-to-bus time','cycling mMETs','walking mMETs','background PM2.5','traffic PM2.5 share',
#                      'non-travel PA','street safety','non-communicable disease burden','all-cause mortality (PA)','IHD (PA)',
#                      'cancer (PA)','lung cancer (PA)','stroke (PA)','diabetes (PA)','IHD (AP)','lung cancer (AP)',
#                      'COPD (AP)','stroke (AP)')
# rownames(evppi) <- parameter_names

voi <- read_csv("new_accra_results/main_analysis/health/uncertainty/voi_deaths.csv")
voi[,2:ncol(voi)] <- round(voi[,2:ncol(voi)],1)
voi <- rename(voi, "var" = "variable")
#voi <- rename(voi, "var" = "X1")

accra_cols <- c("Baseline" = "#e41a1c", 
                "Scenario 1" = "#377eb8", 
                "Scenario 2" = "#4daf4a", 
                "Scenario 3" = "#984ea3",
                "Scenario 4" = "#80b1d3", 
                "Scenario 5" = "#cc4c02")


source("data-processing.R")
# Functions
source("functions.R")