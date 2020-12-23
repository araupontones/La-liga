## chart goles por decada FC Barcelona

source("set_up.R")
df_goles = import(file.path(dir_clean,"la_liga_goles_historico.rds"))
logo = readPNG(file.path("R_charts/icons/barca.png"))
logo <- rasterGrob(logo, interpolate=TRUE)


df_goles_Barcelona = df_goles %>%
  filter(Team == "FC Barcelona",
         decada >="80's") %>%
  group_by(decada, Team_rival) %>%
  summarise(goles_barca = sum(goals_scored)) %>%
  top_n(11) %>%
  arrange(-goles_barca) %>%
  mutate(label = if_else(row_number() <=3, as.character(goles_barca), "")) %>%
  ungroup() %>%
  mutate(decada = as.factor(decada),
         Team_rival = reorder_within(Team_rival, goles_barca, decada))

plot = ggplot(
  data = df_goles_Barcelona,
  aes(Team_rival,
      goles_barca,
      fill = decada)
  
) +
#Bars ----------------------------------------------------------------------
  geom_col(
    show.legend = F
    ) +
  
#Facet ---------------------------------------------------------------------
  facet_wrap(
    ~decada, scales = "free_y"
    ) +
#Labels --------------------------------------------------------------------
  geom_text(
    aes(label = label),
    hjust = 1,
    color = "white",
    family = "F.C. BARCELONA"
    )+
  coord_flip() +
#Captions ------------------------------------------------------------------
  scale_x_reordered() +
  ggtitle("Top 10 de equipos más goleados por el F.C Barcelona") +
  labs(x = "",
       y = "Goles",
       caption = '**Chart:** Andrés Arau |  **Data:** {_engsoccerdata_} | Nov, 2020'
       )+
#Colors ----------------------------------------------------------------------
  scale_fill_manual(
    values = c("#A50044", "#004D98", "#EDBB00",  "#DB0030")
    ) +
#Theme ----------------------------------------------------------------------
  theme(
    plot.background = element_rect(fill = "#181733"),
    panel.background = element_rect(fill = "#181733"),
    panel.grid = element_blank(),
    strip.background = element_blank(),
    strip.text = element_text(color = "#FDC52C", hjust = 0, family = "F.C. BARCELONA", size = 20),
    axis.text = element_text(family = "F.C. BARCELONA", color = "white", size = 12),
    axis.title = element_text(family = "F.C. BARCELONA", size = 20, color = "#FDC52C"),
    plot.caption = element_markdown(color = "#9D9DA9", size = 12, margin = margin(t = 20)),
    plot.title = element_markdown(color = "#FDC52C", size = 20, family = "F.C. BARCELONA", margin = margin( b = 20))
    
    
  )


plot


