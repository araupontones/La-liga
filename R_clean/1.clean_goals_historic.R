

##Cleean data

source("set_up.R")

#read all games of La liga
raw = spain


#Clean to extract local and visitor goals
clean = spain %>%
  #1 goals home
  mutate(goals_home = as.numeric(str_extract(FT, "^.*(?=-)")),
         goals_visitor = as.numeric(str_extract(FT, "(?<=-).*")),
         ID = map2_chr( home, visitor, ~str_flatten(sort(c(.x,.y))) ))
 


## Transform data to have one column per team
home = clean %>%
  select(Season, ID, home, visitor, starts_with("goals_")) %>%
  mutate(Team = home,
         Team_rival = visitor,
         goals_scored = goals_home,
         goals_received = goals_visitor
  ) %>%
  select(Season, ID, Team, Team_rival, goals_scored, goals_received)

away = clean %>%
  select(Season, ID, home, visitor, starts_with("goals_")) %>%
  mutate(Team = visitor,
         Team_rival = home,
         goals_scored = goals_visitor,
         goals_received = goals_home
  ) %>%
  select(Season, ID, Team, Team_rival, goals_scored, goals_received)


## join tables and create decade
historico = rbind(home, away) %>%
  mutate(decada = case_when(Season %in% c(1920:1929) ~ "20's",
                            Season %in% c(1930:1939) ~ "30's",
                            Season %in% c(1940:1949) ~ "40's",
                            Season %in% c(1950:1959) ~ "50's",
                            Season %in% c(1960:1969) ~ "60's",
                            Season %in% c(1970:1979) ~ "70's",
                            Season %in% c(1980:1989) ~ "80's",
                            Season %in% c(1990:1999) ~ "90's",
                            Season %in% c(2000:2009) ~ "2000's",
                            Season %in% c(2010:2019) ~ "2010's",
                            TRUE ~ "2020's"),
         decada = factor(decada,
                         levels = c("20's", "30's", "40's", "50's", "60's", "70's", "80's", "90's",
                                    "2000's", "2010's"),
                         ordered = T
                         )
         
         
  )


export(historico, file.path(dir_clean,"la_liga_goles_historico.rds"))

       