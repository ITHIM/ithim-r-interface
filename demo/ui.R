source("setup.R")
source("modules/csv_module.R")

source("ITHIM_var_setup.r")

countryExData <- read_csv("data/countryExData.csv")
countryExData <- select(countryExData, c("ISO3V10", "Country"))

accra_population <- c('All', 'Male', 'Female')

accra_ages <- append('All', accra_age_cat)

accra_health_ages <- append('All', accra_health_age_cat)

accra_travel_modes <- append('All', accra_modes)

accra_scenarios <- c('scen1' = '50% Walk trips to Car',
                     'scen2' = '<= 7k long Car trips to bike',
                     'scen3' = 'Long Car trips to Bus')

accra_health_outcomes <- c("Deaths", "YLLs")


accra_trip_types <- c("Trips", "Distance", "Duration")




ui <- fluidPage(theme = shinytheme("cerulean"),
                title = "Integrated Transport and Health Impact Modelling Tool (ITHIM)",
                useShinyjs(),
                titlePanel(fluidRow(
                  column(4, tags$a(img(src="./assets/mrc-cam.png", style = "height:50px"), href="http://www.mrc-epid.cam.ac.uk", target="_blank", align="left")),
                  #column(2, tags$a(img(src="cam.png", style = "height:50px"), href="http://www.cam.ac.uk", target="_blank"), align = 'left'),
                  column(2, offset = 6, div(tags$a(img(src="./assets/cedar.png", style = "height:50px"), href="http://www.cedar.iph.cam.ac.uk/", target="_blank")), align="right")
                  
                )),
                
                tabsetPanel(id="tabBox_next_previous",
                            tabPanel("Introduction",
                                     
                                     slickR(obj = c('./www/assets/james1.jpg', './www/assets/leandro.jpg'#, './www/assets/rahul.jpg'
                                     ), slickOpts=list(dots = T, autoplay = T, arrows = F, pauseOnHover = F, fade = T, speed = 750), slideId = 'ex1', width = "100%"),
                                     
                                     
                                     br(),
                                     p(strong('Integrated Transport and Health Impact Modelling Tool (ITHIM)'), " ) was  originally developed out of work for the 
                                       Lancet series on climate change mitigation and health 2009. Initially created as a spreadsheet model, a more recent Analytica 
                                       model has been used in studies including São Paulo and the London Cycle Hire scheme. An international team of researchers is 
                                       moving the model to R with a  ", a("Shiny interface.", href = "http://github.com/ITHIM/ithim-r", target = "_blank"), 
                                       "This is a work in progress involving partners from UK, Switzerland, Brazil, USA and Canada. The work also involves collaboration 
                                       with the World Health Organization, under the Urban Health Initiative, to adapt the tool for settings with limited evidence and data 
                                       availability. "),
                                     tags$ul(
                                       tags$li(p("Please select ", HTML("<cite> User Case Study</cite>"), " where you need to provide data for both baseline and scenarios")),
                                       tags$li(p("Please select ", HTML("<cite> Predefined Case Studies</cite>"), " to see the ITHIM results for predefined locations."))
                                     )
                                     
                                     
                            ),
                            tabPanel("User Case Study",
                                     tabsetPanel(id = "ITHIM",
                                                 tabPanel("Data Sources", value = 2.1,
                                                          sidebarLayout(
                                                            sidebarPanel(
                                                              div(selectInput(inputId = "in_country_list", 
                                                                              label = strong("Select Country for: Global Burden of Disease (GBD)"), choices =  countryExData$Country)
                                                              ),
                                                              HTML("<hr>"),
                                                              selectInput(inputId = "in_city_list", label = strong("Air Pollution: select city"), choices =  ''),
                                                              HTML("<hr>"),
                                                              csvFileUI("datafile_1", "Travel Survey Data (.csv format)"),
                                                              csvFileUI("datafile_2", "Non-travel Physical Activity Data (.csv format)"),
                                                              csvFileUI("datafile_3", "Injury Data (.csv format)")
                                                            ),
                                                            mainPanel(
                                                              fluidRow(dataTableOutput("table_1")),
                                                              fluidRow(dataTableOutput("table_2"))
                                                            )
                                                          )
                                                 ),
                                                 tabPanel("Data Localization", value = 2.2,
                                                          strong('Data Localization: '), 
                                                          p("Using GBD to derive local disease and mortality rates.")),
                                                 tabPanel("Data Harmonization", value = 2.3,
                                                          strong("Data Harmonization: "), 
                                                          p("The process of conversion or matching of various data formats and variable definitions of external data to the generic data formats used in ITHIM. Including"),
                                                          tags$ul(
                                                            tags$li("Transport mode categories"),
                                                            tags$li("Age bands")
                                                          )
                                                 ),
                                                 tabPanel("Synthetic Baseline Data", value = 2.4,
                                                          strong("Synthetic population: "),
                                                          p("The process of creating a Synthetic population (sample of 10k individuals), through probabilistic matching of 
                                                            separate input data from population, travel, and health surveys, for baseline.")
                                                 ),
                                                 tabPanel("Scenario Definitions", value = 2.5,
                                                          strong("Scenario Definitions: "),
                                                          p("The process of creating scenarios based on user-inputs. Users are given options to describe scenarios, by modifdyign baseline's data.")
                                                 ),
                                                 tabPanel("Physical Activity", value = 2.6,
                                                          strong("Physical activity: "),
                                                          p("ITHIM uses ",  a("non-linear dose response relationships", 
                                                                              href = "https://shiny.mrc-epid.cam.ac.uk/meta-analyses-physical-activity/",
                                                                              target = "_blank"),
                                                            " based on total physical activity and applies these individual diseases. This approach allows that baseline 
                                                            travel and non-travel physical activity vary between populations and that the relative burden of diseases varies between countries.")
                                                 ),
                                                 tabPanel("Air Pollution", value = 2.7,
                                                          strong("Air Pollution: "),
                                                          p("Just like Physical Activity, ITHIM uses a non-linear dose relationship for calculating Air Pollution impacts.  ")
                                                  ),
                                                 tabPanel("Injury", value = 2.8,
                                                          strong("Road traffic injuries: "),
                                                          p("Unlike most other models of walking and cycling ITHIM estimates injuries taking into account all the parties involved in collision. ITHIM uses a non-linear distance based method. That is the number of injuries is dependent on the distance travelled by all modes, but it is non-linear because it includes ‘safety-in-numbers’.")
                                                 ),
                                                 tabPanel("Health Impacts", value = 2.9,
                                                          strong("Health Impacts: "),
                                                          p("Calculates health gains measured as Years of Life Lost (YLL) and Premature Deaths Averted. The baseline for health comes from Global Burden of Disease Study")
                                                          )
                                                 
                                     )
                            ),
                            navbarMenu("Predefined Case Studies",
                                       tabPanel("Accra",
                                                sidebarPanel(
                                                  #radioButtons(inputId = "inAccraScenario", label = "Scenario:", 
                                                  #             accra_scenarios),
                                                  #HTML("<hr>"),
                                                  
                                                  tags$div(
                                                    tags$h4(
                                                      tags$b(HTML("<font color='red'>Prototype</font>"))
                                                    )
                                                  ),
                                                  hr(),
                                                  
                                                  tags$div(
                                                    tags$h4(
                                                      tags$b(HTML("<font color='black'>Scenario 1</font>")),
                                                      HTML("<font color='black'>walk to car</font>"),
                                                      br(),
                                                      tags$b(HTML("<font color='black'>Scenario 2</font>")),
                                                      HTML("<font color='black'>short car to bike</font>"),
                                                      br(),
                                                      tags$b(HTML("<font color='black'>Scenario 3</font>")),
                                                      HTML("<font color='black'>long  car to bus</font>"),
                                                      HTML("<hr>"))
                                                    
                                                    
                                                    ),
                                                      
                                                      
                                                      # tags$b("Scenario 1"), "walk to car")),
                                                  #   Scenario 2 short car to bike
                                                  #   Scenario 3 long  car to bus "
                                                  # )),
                                                  
                                                  conditionalPanel(condition = "input.accraConditionedPanels == 'Mode'",
                                                                   radioButtons("inAccraPop", "Gender: ", accra_population),
                                                                   HTML("<hr>"),
                                                                   radioButtons("inAccraAges", "Age: ", accra_ages),
                                                                   HTML("<hr>"),
                                                                   radioButtons("inAccraTripTypes", "Type: ", accra_trip_types)
                                                  ),
                                                  
                                                  conditionalPanel(condition = "input.accraConditionedPanels == 'Health'",
                                                                   radioButtons("inAccraHealthOutcome", "Outcome: ", accra_health_outcomes),
                                                                   HTML("<hr>"),
                                                                   radioButtons("inAccraHealthPop", "Gender: ", accra_population),
                                                                   HTML("<hr>"),
                                                                   radioButtons("inAccraHealthAges", "Age: ", accra_health_ages)
                                                  ),
                                                  
                                                  HTML("<hr>"),
                                                  div(HTML("<font color=\"#FF0000\">Preliminary Results</font>"))
                                                  
                                                ),
                                                
                                                mainPanel(
                                                  tabsetPanel (
                                                    
                                                    tabPanel('Mode',
                                                             plotlyOutput("plotAccraModes")
                                                             
                                                    ),
                                                    
                                                    tabPanel('Physical Activity',
                                                             plotlyOutput("plotScenariosPA")
                                                    ),
                                                    
                                                    
                                                    tabPanel('Health',
                                                             plotlyOutput("plotScenariosHealthOutcome")
                                                             
                                                                          
                                                             )
                                                    
                                                    
                                                    
                                                    
                                                    #,
                                                    # tabPanel('Road Injuries',
                                                    #           plotlyOutput('plotInjuries')
                                                    # 
                                                    # )
                                                    
                                                    
                                                    #tabPanel('Health Outcomes',
                                                    #         showOutput("plotBaselineDeaths", "highcharts"),
                                                    #         showOutput("plotScenarioDeaths", "highcharts")
                                                             
                                                    #)
                                                    
                                                    
                                                    
                                                    ,
                                                    id = "accraConditionedPanels"
                                                  )
                                                )
                                       )
                                       
                                       ,
                                       tabPanel("England",
                                                
                                                selectInput(inputId = "inRegions", label = "Select Region:", choices =  regions),
                                                sidebarPanel(
                                                  
                                                  tags$div(title="Shows % of the total population for the selected region who cycle at least weekly at baseline",
                                                           uiOutput("inBaselineCycling")
                                                  ),
                                                  
                                                  HTML("<hr>"),
                                                  conditionalPanel(condition="input.conditionedPanels == 1",
                                                                   tags$div(title="Select percentage of total regional population who are as likely to cycle based on trip distance as existing cyclists",
                                                                            selectInput(inputId = "inBDMS", label = "Select % of Population who are Regular Cyclists:", choices =  uniqueMS)
                                                                   ),
                                                                   hidden(
                                                                     radioButtons(inputId = "inBDEQ", label = "Select Equity (EQ):", onOffRButton, inline = TRUE),
                                                                     radioButtons(inputId = "inBDEB", label = "Select Ebike (EB):", onOffRButton, selected = onOffRButton[2], inline = TRUE)
                                                                   ),
                                                                   HTML("<hr>"),
                                                                   selectizeInput("inBDAG", "Age Group:", ag, selected = ag[1], multiple = F),
                                                                   radioButtons("inBDGender", "Gender: ", gender, inline = TRUE),
                                                                   selectizeInput("inBDSES", "Socio Economic Classification :", ses, selected = ses[1], multiple = F),
                                                                   hidden(
                                                                     radioButtons("inBDEthnicity", label = "Ethnic Group:", ethnicity, inline = TRUE)
                                                                   ),
                                                                   HTML("<hr>"),
                                                                   radioButtons("flipMS", label = "Flip Histogram:", switchRButton, inline = TRUE)
                                                                   
                                                  ),
                                                  conditionalPanel(condition="input.conditionedPanels == 2",
                                                                   selectInput(inputId = "inTTMS", label = "Select % of Population who are Regular Cyclists:", choices =  uniqueMS),#, selected = uBDMS[2]),
                                                                   hidden(
                                                                     radioButtons(inputId = "inTTEQ", label = "Select Equity (EQ):", onOffRButton, inline = TRUE),
                                                                     radioButtons(inputId = "inTTEB", label = "Select Ebike (EB):", onOffRButton, selected = onOffRButton[2], inline = TRUE)
                                                                   ),
                                                                   HTML("<hr>"),
                                                                   selectizeInput("inTTAG", "Age Group:", ag, selected = ag[1], multiple = F),
                                                                   radioButtons("inTTGender", "Gender: ", gender, inline = TRUE),
                                                                   selectizeInput("inTTSES", "Socio Economic Classification :", ses, selected = ses[1], multiple = F),
                                                                   hidden(
                                                                     radioButtons("inTTEthnicity", label = "Ethnic Group:", ethnicity, inline = TRUE)
                                                                   ),
                                                                   HTML("<hr>"),
                                                                   radioButtons("flipTTPlot", label = "Flip Plot:", TTRButton, inline = TRUE)
                                                                   
                                                  ),
                                                  conditionalPanel(condition="input.conditionedPanels == 3",
                                                                   selectInput(inputId = "inMSMS", label = "Select % of Population who are Regular Cyclists:", choices =  uniqueMS),#uBDMS, selected = uBDMS[2]),
                                                                   hidden(
                                                                     radioButtons(inputId = "inMSEQ", label = "Select Equity (EQ):", onOffRButton, inline = TRUE),
                                                                     radioButtons(inputId = "inMSEB", label = "Select Ebike (EB):", onOffRButton, selected = onOffRButton[2], inline = TRUE)
                                                                   ),
                                                                   HTML("<hr>"),
                                                                   selectizeInput("inMSAG", "Age Group:", ag, multiple = F),
                                                                   radioButtons("inMSG", "Gender: ", gender, inline = TRUE),
                                                                   selectizeInput("inMSSES", "Socio Economic Classification :", ses, multiple = F),
                                                                   hidden(
                                                                     radioButtons("inMSEthnicity", label = "Ethnic Group:", ethnicity, inline = TRUE)
                                                                   ),
                                                                   HTML("<hr>"),
                                                                   radioButtons("inMSflip", label = "Flip Histogram:", switchRButton, inline = TRUE),
                                                                   HTML("<hr>"),
                                                                   radioButtons("inMSTotOrCyc", label = "Denominator:", denominatorRButton, inline = TRUE)
                                                  ),
                                                  conditionalPanel(condition="input.conditionedPanels == 4",
                                                                   
                                                                   tags$div(title="Select percentage of total regional population who are as likely to cycle based on trip distance as existing cyclists",
                                                                            selectInput(inputId = "inMETMS", label = "Select % of Population who are Regular Cyclists:", choices =  uniqueMS)
                                                                   ),
                                                                   hidden(
                                                                     radioButtons("inMETEQ", "Select Equity (EQ):", onOffRButton, inline = TRUE),
                                                                     radioButtons("inMETEB", "Select Ebike (EB):", onOffRButton, selected = onOffRButton[2], inline = TRUE)
                                                                   ),
                                                                   
                                                                   HTML("<hr>"),
                                                                   selectizeInput("mag", "Age Group:", ag, selected = ag[1], multiple = F),
                                                                   radioButtons("mgender", "Gender: ", gender, inline = TRUE),
                                                                   selectizeInput("mses", "Socio Economic Classification :", ses, selected = ses[1], multiple = F),
                                                                   hidden(
                                                                     radioButtons("methnicity", label = "Ethnic Group:", ethnicity, inline = TRUE)
                                                                   ),
                                                                   HTML("<hr>"),
                                                                   radioButtons("flipMETHG", label = "Flip Histogram:", switchRButton, inline = TRUE),
                                                                   HTML("<hr>"),
                                                                   radioButtons("phyGuideline", label = "Physical activity outcome measure:", phyGLRButton, inline = TRUE)
                                                  )
                                                  ,
                                                  conditionalPanel(condition="input.conditionedPanels == 5",
                                                                   selectInput(inputId = "inHealthMS", label = "Select % of Population who are Regular Cyclists:", choices =  uniqueMS),#uBDMS, selected = uBDMS[2]),
                                                                   hidden(
                                                                     radioButtons(inputId = "inHealthEQ", label = "Select Equity (EQ):", onOffRButton, inline = TRUE),
                                                                     radioButtons(inputId = "inHealthEB", label = "Select Ebike (EB):", onOffRButton, selected = onOffRButton[2], inline = TRUE)
                                                                   ),
                                                                   HTML("<hr>"),
                                                                   radioButtons("inHealthSwitch", label = "Comparison with:", c("Baseline" = "Baseline","An alternative scenario/Region"= "Scenario"), inline = TRUE),
                                                                   HTML("<hr>"),
                                                                   conditionalPanel(
                                                                     condition = "input.inHealthSwitch == 'Scenario'",
                                                                     selectInput(inputId = "inRegionSelectedHealth", label = "Select Region:", choices = regionsList),
                                                                     hidden(p(id = "region-health-switch-warning", class = "region-switch-warnings", "")),
                                                                     selectInput(inputId = "inHealthMS1", label = "Select % of Population who are Regular Cyclists:", choices =  uniqueMS),
                                                                     hidden(
                                                                       radioButtons(inputId = "inHealthEQ1", label = "Select Equity (EQ):", onOffRButton, inline = TRUE),
                                                                       radioButtons(inputId = "inHealthEB1", label = "Select Ebike (EB):", onOffRButton, selected = onOffRButton[2], inline = TRUE)
                                                                     )
                                                                   ),
                                                                   HTML("<hr>"),
                                                                   # Use same age groups for now
                                                                   selectizeInput("inHealthAG", "Age Group:", healthAG, selected = healthAG[1], multiple = F),
                                                                   radioButtons("inHealthG", "Gender: ", gender, inline = TRUE),
                                                                   HTML("<hr>"),
                                                                   radioButtons("inHealthVarSwitch", label = "Variable:", healthRButton, inline = TRUE)
                                                                   
                                                  ),
                                                  conditionalPanel(condition="input.conditionedPanels == 6",
                                                                   selectInput(inputId = "inCMMS", label = "Select % of Population who are Regular Cyclists:", choices =  uniqueMS),#uBDMS, selected = uBDMS[2]),
                                                                   hidden(
                                                                     radioButtons(inputId = "inCMEQ", label = "Select Equity (EQ):", onOffRButton, inline = TRUE),
                                                                     radioButtons(inputId = "inCMEB", label = "Select Ebike (EB):", onOffRButton, selected = onOffRButton[2], inline = TRUE)
                                                                   ),
                                                                   HTML("<hr>"),
                                                                   selectizeInput("inCMAG", "Age Group:", ag, multiple = F),
                                                                   radioButtons("inCMG", "Gender: ", gender, inline = TRUE),
                                                                   selectizeInput("inCMSES", "Socio Economic Classification :", ses),
                                                                   hidden(
                                                                     radioButtons("inCMEthnicity", label = "Ethnic Group:", ethnicity, inline = TRUE)
                                                                   ),
                                                                   
                                                                   HTML("<hr>"),
                                                                   radioButtons("inCMflip", label = "Flip Histogram:", switchRButton, inline = TRUE)
                                                                   
                                                  ),
                                                  conditionalPanel(condition="input.conditionedPanels == 7",
                                                                   tags$div(title="Select percentage of total regional population who are as likely to cycle based on trip distance as existing cyclists",
                                                                            selectInput(inputId = "inCO2MS", label = "Select % of Population who are Regular Cyclists:", choices =  uniqueMS)
                                                                   ),
                                                                   hidden(
                                                                     radioButtons(inputId = "inCO2EQ", label = "Select Equity (EQ):", onOffRButton, inline = TRUE),
                                                                     radioButtons(inputId = "inCO2EB", label = "Select Ebike (EB):", onOffRButton, selected = onOffRButton[2], inline = TRUE)
                                                                   ),
                                                                   HTML("<hr>"),
                                                                   selectizeInput("inCO2AG", "Age Group:", ag, multiple = F),
                                                                   radioButtons("inCO2G", "Gender: ", gender, inline = TRUE),
                                                                   selectizeInput("inCO2SES", "Socio Economic Classification :", ses),
                                                                   hidden(
                                                                     radioButtons("inCO2Ethnicity", label = "Ethnic Group:", ethnicity, inline = TRUE)
                                                                   ),
                                                                   HTML("<hr>"),
                                                                   radioButtons("inCO2flip", label = "Flip Histogram:", switchRButton, inline = TRUE)
                                                  ),
                                                  
                                                  conditionalPanel(condition="input.conditionedPanels == 8",
                                                                   tags$div(title="Select percentage of total regional population who are as likely to cycle based on trip distance as existing cyclists",
                                                                            selectInput(inputId = "inBDMS", label = "Select % of Population who are Regular Cyclists:", choices =  uniqueMS)
                                                                   ),
                                                                   hidden(
                                                                     radioButtons(inputId = "inIEQ", label = "Select Equity (EQ):", onOffRButton, inline = TRUE),
                                                                     radioButtons(inputId = "inIEB", label = "Select Ebike (EB):", onOffRButton, selected = onOffRButton[2], inline = TRUE)
                                                                   ),
                                                                   HTML("<hr>"),
                                                                   selectizeInput("inIAG", "Age Group:", ag, selected = ag[1], multiple = F),
                                                                   radioButtons("inIGender", "Gender: ", gender, inline = TRUE),
                                                                   selectizeInput("inISES", "Socio Economic Classification :", ses, selected = ses[1], multiple = F),
                                                                   hidden(
                                                                     radioButtons("inIEthnicity", label = "Ethnic Group:", ethnicity, inline = TRUE)
                                                                   )
                                                                   
                                                  ),
                                                  
                                                  conditionalPanel(condition="input.conditionedPanels == 9",
                                                                   tags$div(title="Select percentage of total regional population who are as likely to cycle based on trip distance as existing cyclists",
                                                                            selectInput(inputId = "inAPMS", label = "Select % of Population who are Regular Cyclists:", choices =  uniqueMS)
                                                                   ),
                                                                   hidden(
                                                                     radioButtons(inputId = "inAPEQ", label = "Select Equity (EQ):", onOffRButton, inline = TRUE),
                                                                     radioButtons(inputId = "inAPEB", label = "Select Ebike (EB):", onOffRButton, selected = onOffRButton[2], inline = TRUE)
                                                                   ),
                                                                   HTML("<hr>"),
                                                                   selectizeInput("inAPAG", "Age Group:", ag, selected = ag[1], multiple = F),
                                                                   radioButtons("inAPGender", "Gender: ", gender, inline = TRUE),
                                                                   selectizeInput("inAPSES", "Socio Economic Classification :", ses, selected = ses[1], multiple = F),
                                                                   hidden(
                                                                     radioButtons("inAPEthnicity", label = "Ethnic Group:", ethnicity, inline = TRUE)
                                                                   )
                                                                   
                                                  ),
                                                  conditionalPanel(condition="input.conditionedPanels == 10",
                                                                   hidden(
                                                                     radioButtons(inputId = "inEQ", label = "Select Equity (EQ):", allOnOffRButton, inline = TRUE),
                                                                     radioButtons(inputId = "inEB", label = "Select Ebike (EB):", allOnOffRButton, inline = TRUE)
                                                                   ),
                                                                   HTML("<hr>"),
                                                                   
                                                                   radioButtons("varname", label = "Plot Variable:", variableRButton),
                                                                   
                                                                   conditionalPanel(
                                                                     condition = "input.varname == 'Car Miles Per person (per week)'",
                                                                     radioButtons("CMVarName", label = "Car Miles Variable:", carMilesRButton)
                                                                   ),
                                                                   
                                                                   
                                                                   conditionalPanel(
                                                                     condition = "input.varname == 'Years of Life Lost (YLL)'",
                                                                     radioButtons("HVarName", label = "Health Variable:", summaryhealthRButton)
                                                                   )
                                                  ),
                                                  
                                                  
                                                  
                                                  
                                                  
                                                  
                                                  
                                                  
                                                  # for now only "Mode Share", "Miles Cycled", "Physical Activity", "Car Miles", "CO2"
                                                  conditionalPanel(condition="[1, 3, 4, 6, 7].indexOf(parseInt(input.conditionedPanels)) > -1",
                                                                   HTML("<hr>"),
                                                                   radioButtons("inRegionSwitch", label = "Comparison with:", c("Baseline" = "Baseline", "An alternative Region" = "Region"), inline = TRUE),
                                                                   conditionalPanel(
                                                                     condition = "input.inRegionSwitch == 'Region'",
                                                                     HTML("<hr>"),
                                                                     selectInput(inputId = "inRegionSelected", label = "Select Region:", choices = regionsList),
                                                                     hidden(p(id = "region-switch-warning", class = "region-switch-warnings", ""))
                                                                   )
                                                  )
                                                ),
                                                mainPanel(
                                                  tabsetPanel(
                                                    tabPanel("Mode Share", value = 1,
                                                             a(id = "MSHelp", "Help?", href = "#"),
                                                             hidden (div(id = "MSHelpText",
                                                                         helpText(HTML("Displays plots for mode share of trips based on main mode only. A scenario is selected by a combination of 
                                                                                      three inputs: % of Population who are Regular Cyclists, Equity and Ebike. Users can choose to compare mode share between selected 
                                                                                      sub-populations and the total population, and/or between selected scenarios and baseline."))
                                                             )),
                                                             showOutput("plotBDMode", "highcharts"),
                                                             showOutput("plotBDSCMode", "highcharts")
                                                    ),
                                                    tabPanel("Physical Activity", value = 4,
                                                             a(id = "PAHelp", "Help?", href = "#"),
                                                             hidden (div(id = "PAHelpText",
                                                                         helpText(
                                                                           p("Displays histogram of total physical activity and also the percentage of the population meeting the physical activity guidelines of the World Health Organization (WHO). "),
                                                                           p(HTML("The <a href='http://www.who.int/dietphysicalactivity/factsheet_recommendations/en/' target='_blank'>WHO guidelines</a> are for 150 minutes of moderate intensity or 75 minutes of vigorous intensity activity, 
                                                                                 with additional benefits by achieving 300 minutes of moderate intensity or 150 minutes of vigorous intensity activity. We have translated these guidelines into Marginal Metabolic Equivalent Task (MMET) 
                                                                                 hours per week. MMETs represent the body mass adjusted energy expenditure above resting. 
                                                                                 To do this we have assumed that moderate intensity activity is 3.5 MMETs, meaning that the lower target is 8.75 MMET hours per week, 
                                                                                 and the higher target is 17.5 MMET hours per week. We have assumed the MMET rates are 3.6 for walking, 5.4 for cycling, and 3.5 for ebikes (<a href='http://www.ncbi.nlm.nih.gov/pubmed/26441297' target='_blank'>Costa et al., 2015</a>  and <a href='http://link.springer.com/article/10.1007/s00421-012-2382-0/fulltext.html' target='_blank'>Sperlich et al., 2012</a>). 
                                                                                 Thus the lower target could be achieved by 145 minutes per week of walking, 97 minutes of cycling, or 150 minutes of ebiking. ")),
                                                                           p(HTML("Non-travel activity is estimated using self-reported data from probabilistically matched individuals of a similar age, gender, and ethnicity from the <a href = 'https://data.gov.uk/dataset/health_survey_for_england' target='_blank'>Health Survey for England 2012</a>. ")),
                                                                           p("Users can choose to compare physical activity between selected sub-populations and the total population, and/or between selected scenarios and baseline. "))
                                                             )),
                                                             showOutput("plotMET", "highcharts"),
                                                             showOutput("plotScenarioMET", "highcharts")
                                                    ),
                                                    
                                                    
                                                    tabPanel(HTML("CO<sub>2<sub>"), value = 7,
                                                             a(id = "CO2Help", "Help?", href = "#"),
                                                             hidden (div(id = "CO2HelpText",
                                                                         helpText(HTML("Population distributions of CO2 from car travel - for  CO2 reduced see Summary tab. Displays two plots 
                                         for CO2 produced during car travel, defined as travel as a car/van driver or car/van passenger. 
                                         Users can choose to compare CO2 emissions from car travel between selected sub-populations and the 
                                         total population, and/or between selected scenarios and baseline.")))),
                                                             showOutput("plotFilteredCO2", "highcharts"),
                                                             showOutput("plotCO2", "highcharts")
                                                    ),
                                                    
                                                    tabPanel("Air Pollution", value = 8,
                                                             strong("Air Pollution: "),
                                                             p("Just like Physical Activity, ITHIM uses a non-linear dose relationship for calculating Air Pollution impacts.  ")
                                                    ),
                                                    tabPanel("Injury", value = 9,
                                                             strong("Road traffic injuries: "),
                                                             p("Unlike most other models of walking and cycling ITHIM estimates injuries taking into account all the parties involved in collision. ITHIM uses a non-linear distance based method. That is the number of injuries is dependent on the distance travelled by all modes, but it is non-linear because it includes ‘safety-in-numbers’.")
                                                    ),
                                                    
                                                    tabPanel("Health", value = 5,
                                                             a(id = "HealthHelp", "Help?", href = "#"),
                                                             hidden (div(id = "HealthHelpText",
                                                                         helpText(HTML("
                                                                                       Displays two plots for health gains measured as Years of Life Lost (YLL) and Premature Deaths Averted. 
                                                                                       YLLs are taken from the <a href='http://www.healthdata.org/gbd' target='_blank'>Global Burden of Disease Study for the UK 2013</a>. 
                                                                                       YLL is an estimate of the age specific life expectancy against an &#39;ideal&#39; reference population. 
                                                                                       A scenario is selected by a combination of three inputs: % of Population who are Regular Cyclists, Equity and Ebike &#45; 
                                                                                       this scenario can then be compared against baseline or against an alternative scenario. Results are presented by 
                                                                                       age and gender, or the display can be restricted to particular age and gender groups using the subpopulation option. "))
                                                                         )),
                                                             showOutput("plotHealth", "highcharts"),
                                                             showOutput("plotHealthReduction", "highcharts")
                                                    ),
                                                    tabPanel("Summary", value = 10,
                                                             showOutput("plotGenericVariable", "highcharts")
                                                    ),
                                                    
                                                    id = "conditionedPanels"
                                                  )
                                                )
                                       )
                                       
                                       
                            ),
                            tabPanel('About',
                                     includeHTML("about.html"))
                            
                            
                            
                )
)