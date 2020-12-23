#Set up

library(pacman)

p_load(engsoccerdata, tidyverse, tidytext, extrafont, ggtext, png, grid, extrafont)


#Define directories
dir_clean = "clean_data"


fonts()
font_import(paths = "C:/Users/andre/AppData/Local/Microsoft/Windows/Fonts")
loadfonts(device = "win")
