regions <- generateRegionsList()

# Mode Share
# Miles Cycled
# Physical Activity
# Health
# Car Miles
# CO2

variableRButton <- c("Number of Cyclists" =    "% Cyclists in the Total Population",
                     "Physical Activity" = "Travel Marginal METs Per Person (per week)",
                     "Health" = "Years of Life Lost (YLL)",
                     "CO2" = "Transport CO2 Per Person (per week)"
)
carMilesRButton <- c("Car Miles" = "Car Miles Per person (per week)",
                     "Car Miles Reduced" = "Car Miles Reduced Per person (per week)")

summaryhealthRButton <- c("Health" = "Years of Life Lost (YLL)",
                          "Health benefit - YLL reduciton" = "Years of Life Lost (YLL) reduction (%)")


# % cyclists in the total population	Miles cycled per person per week	Car miles cycled  per week	Marginal METs per person per week	Car miles per person per week	Car miles reduced per person per week	CO2 from car travel per person per week


scenarios <- c("Trip Mode Share" = "t",
               "Individual METs" =    "i")

METSwitchRButton <- c("Baseline and Scenario" = "sep",
                      "Scenario versus Baseline" =    "comp")

switchRButton <- c("Scenario versus Baseline/alternative Scenario" =    "comp",
                   "Sub-population versus total population" = "sep")

denominatorRButton <- c("Total Population" = "pop",
                        "Total Cyclists" = "cyc")

# denominatorRButton <- c("Total Cyclists" = "cyc")


phyGLRButton <- c("% meeting WHO physical activity guidelines" = "on",
                  "Marginal MET hours" =    "off")

TTRButton <- c("Slower/Faster trips" = "trip speed",
               "Histogram" =    "histogram")

onOffRButton <- c("On" = 1,
                  "Off" = 0)

allOnOffRButton <- c("All" = "All",
                     "On" = 1,
                     "Off" = 0)

healthRButton <- c("Years of Life Lost (YLL)" = "YLL", 
                   "Deaths" = "Deaths")

ag <- c("All", "18 - 29", "30 - 39", "40 - 49", "50 - 59", "60 - 69", "70 - 79")

healthAG <- c("All", "18 - 39", "40 - 59", "60 - 79")

ses <- c("All" = "All",
         "Managerial and professional occupations" = 1,
         "Intermediate occupations and small employers" = 2,
         "Routine and manual occupations" = 3,
         "Never worked and long-term unemployed" = 4,
         "Not classified (including students)" = 5)

ethnicity <- c("All" = "All", "White" = 1, "Non-white" = 2)

gender <- c("All" = 3,
            "Male" = 1,
            "Female" = 2)

genderForHealthCalculations <- c("All", 
                                 "Male",
                                 "Female")

# default MS/DP values are: 0.05 0.10 0.15 0.25 0.50 0.75 1.00
# for init use the first (default) region from the list
uniqueMS <- generateUniqueMS(region=unname(regions[1]))

# for init use the first (default) region from the list
# used in "Mode Share" in alternative region
regionsList <- generateRegionsList(region=unname(regions[1]))

# # default MS/DP values are: 0.05 0.10 0.15 0.25 0.50 0.75 1.00
# # for init use the first (default) region from the list
# uniqueMS <- c(0.05, 0.10, 0.15, 0.25, 0.50, 0.75, 1.00)
# 
# # for init use the first (default) region from the list
# # used in "Mode Share" in alternative region
# regionsList <- 'England'
