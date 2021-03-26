#Code to run the model and generate results for web interface related to the paper:
#Health impacts of changes in travel patterns in Greater Accra Metropolitan Area, Ghana
#Results in https://shiny.mrc-epid.cam.ac.uk/ithim/.

#Code by Leandro Garcia (l.garcia@qub.ac.uk).
#August 2020.
#R version 4.0.2

#Build ITHIM package####
package.check <- lapply("devtools", FUN = function(x) {
  if (!require(x, character.only = TRUE)) {
    install.packages(x, dependencies = TRUE)
    library(x, character.only = TRUE)
  }
}
)
install(dependencies = TRUE, upgrade = "never")

#Call packages and clean global environment####
packages = c("tidyverse", "earth", "ithimr")
package.check <- lapply(packages, FUN = function(x) {
  if (!require(x, character.only = TRUE)) {
    install.packages(x, dependencies = TRUE)
    library(x, character.only = TRUE)
  }
}
)
rm(list = ls())

#Create ITHIM object according to parameters####
ithim_object <- run_ithim_setup(seed = 1,
                                CITY = 'accra',
                                REFERENCE_SCENARIO = 'Scenario 1',
                                NSAMPLES = 1,
                                BUS_WALK_TIME = 5,
                                MMET_CYCLING = 4.63,
                                MMET_WALKING = 2.53,
                                PM_CONC_BASE = 50,
                                PM_TRANS_SHARE = 0.23,
                                PA_DOSE_RESPONSE_QUANTILE = F,
                                AP_DOSE_RESPONSE_QUANTILE = F,
                                BACKGROUND_PA_SCALAR = 1,
                                INJURY_REPORTING_RATE = 0.73,
                                CHRONIC_DISEASE_SCALAR = 1,
                                SIN_EXPONENT_SUM = 1.7,
                                CASUALTY_EXPONENT_FRACTION = 0.5)

#Calculate outcomes####
ithim_object$outcomes <- run_ithim(ithim_object)

#Air pollution####
ithim_object$outcomes$scenario_pm <- (t(round(ithim_object$outcomes$scenario_pm, digits = 1)))
colnames(ithim_object$outcomes$scenario_pm) <- c("base_emissions", "scen1_emissions", "scen2_emissions",
                                                      "scen3_emissions", "scen4_emissions", "scen5_emissions")
write.csv(ithim_object$outcomes$scenario_pm, "conc_pm.csv", row.names = F)


ithim_object$outcomes$pm_conc_pp %>% dplyr::select(participant_id, starts_with("pm_conc_")) %>%
  arrange(participant_id) %>% 
  write.csv(., "individual_level_pm_conc_scenarios.csv", row.names = F)

#Health####
write.csv(DISEASE_INVENTORY, "disease_outcomes_lookup.csv", row.names = F)
write.csv(ithim_object$outcomes$hb$deaths, "total_deaths.csv", row.names = F)
write.csv(ithim_object$outcomes$hb$ylls, "total_ylls.csv", row.names = F)

#Road deaths####
injuries_long <- ithim_object$outcomes$injuries %>% dplyr::select(!c(bus_driver, rail, truck, sex_age, dem_index, Deaths)) %>%
  mutate(total = bicycle + bus + car + motorcycle + pedestrian) %>%
  pivot_longer(cols = c(bicycle, bus, car, motorcycle, pedestrian, total), names_to = "variable")

write.csv(injuries_long, "deaths_by_mode_long.csv", row.names = F)

injuries_long %>% group_by(scenario, variable) %>%
  summarise(value = sum(value)) %>%
  pivot_wider(names_from = scenario, values_from = value) %>%
  dplyr::rename(Modes = variable) %>%
  write.csv(., "mode-specific-injuries.csv", row.names = F)

#Physical activity####
write.csv(ithim_object$outcomes$mmets, "pa_total_mmet_weekly.csv", row.names = F)

###END OF CODE###