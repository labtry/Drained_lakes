library(plotly)
library(extrafont)

#font <- "Helvetica"
font <- "Arial"

loadfonts()

#Yedoma_4
data <- data.frame(Category = c("Small lake", "Large lake", "Medium lake", "All lake"),
                   Yedoma = c(0.806,1.484,1.012,0.873),
                   Nonyedoma = c(0.630,0.310,0.464,0.593),
                   All = c(0.638,0.377,0.497,0.606))

data <- rbind(data, data[1,])

fig <- plot_ly(data, type = "scatterpolar", mode = "lines",
               theta = c("Small lake", "Large lake", "Medium lake", "All lake", "Small lake"),
               r = ~Yedoma, line = list(color = "blue", font = list(family = font)), name = "Yedoma region") %>%
       add_trace(r = ~Nonyedoma, line = list(color = "orange", font = list(family = font)), name = "Non-yedoma region") %>%
       add_trace(r = ~All, line = list(color = "green", font = list(family = font)), name = "Entire study area") %>%
       layout(polar = list(radialaxis = list(visible = TRUE, range = c(0, 1.5), tickvals = seq(0, 1.5, by = 0.3),
                                            tickfont = list(family = font, size = 24),tickangle = 0)), 
											showlegend = TRUE, font = list(family = font, size = 26),
											legend = list(font = list(family = font, size = 26)),
											margin = list(l = 80, r = 80, t = 80, b = 80)
											 )

plotly::orca(fig, file = "Yedoma3.png", format = "png", width = 800, height = 600, scale = 5)

#地冰含量
data <- data.frame(Category = c("Small lake", "Large lake", "Medium lake", "All lake"),
                   Low = c(0.653,0.190,0.360,0.589),
                   Medium = c(0.808,0.687,0.928,0.827),
                   High = c(0.494,0.619,0.539,0.505))

data <- rbind(data, data[1,])

fig <- plot_ly(data, type = "scatterpolar", mode = "lines",
               theta = c("Small lake", "Large lake", "Medium lake", "All lake", "Small lake"),
               r = ~Low, line = list(color = "blue", font = list(family = font)), name = "Low Ground ice content") %>%
       add_trace(r = ~Medium, line = list(color = "orange", font = list(family = font)), name = "Medium") %>%
       add_trace(r = ~High, line = list(color = "green", font = list(family = font)), name = "High") %>%
       layout(polar = list(radialaxis = list(visible = TRUE, range = c(0, 1.5), tickvals = seq(0, 1.5, by = 0.3),
                                            tickfont = list(family = font, size = 24),tickangle = 0)), 
											showlegend = TRUE, font = list(family = font, size = 26),
											legend = list(font = list(family = font, size = 26)),
											margin = list(l = 80, r = 80, t = 80, b = 80)
											 )

plotly::orca(fig, file = "Ground_ice.png", format = "png", width = 800, height = 600, scale = 5)



#冻土连续性
data <- data.frame(Category = c("Small lake", "Large lake", "Medium lake", "All lake"),
                   Continu = c(0.404,0.344,0.329,0.389),
                   Discontinu = c(1.331,0.785,1.275,1.310),
                   Sporadic = c(0.654,0.257,0.483,0.617),
				   Isolate = c(0.882,0.267,0.399,0.769))

data <- rbind(data, data[1,])

fig <- plot_ly(data, type = "scatterpolar", mode = "lines",
               theta = c("Small lake", "Large lake", "Medium lake", "All lake", "Small lake"),
               r = ~Continu, line = list(color = "blue", font = list(family = font)), name = "Continuous Permafrost extent") %>%
       add_trace(r = ~Discontinu, line = list(color = "orange", font = list(family = font)), name = "Discontinuous") %>%
       add_trace(r = ~Sporadic, line = list(color = "green", font = list(family = font)), name = "Sporadic") %>%
	   add_trace(r = ~Isolate, line = list(color = "yellow", font = list(family = font)), name = "Isolate") %>%
	   layout(polar = list(radialaxis = list(visible = TRUE, range = c(0, 1.5), tickvals = seq(0, 1.5, by = 0.3),
                                            tickfont = list(family = font, size = 24),tickangle = 0)), 
											showlegend = TRUE, font = list(family = font, size = 26),
											legend = list(font = list(family = font, size = 26)),
											margin = list(l = 80, r = 80, t = 80, b = 80)
											 )

plotly::orca(fig, file = "Permafrost_extent.png", format = "png", width = 800, height = 600, scale = 5)


'''
Very likely thermokarst lake
Likely thermokarst lake
Unlikely thermokarst lake
'''

#热融湖分布
data <- data.frame(Category = c("Small lake", "Large lake", "Medium lake", "All lake"),
                   Highly = c(0.708,1.049,1.017,0.779),
                   Moderately = c(0.620,0.307,0.584,0.608),
                   Unlikely = c(0.623,0.158,0.285,0.551))

data <- rbind(data, data[1,])

fig <- plot_ly(data, type = "scatterpolar", mode = "lines",
               theta = c("Small lake", "Large lake", "Medium lake", "All lake", "Small lake"),
               r = ~Highly, line = list(color = "blue", font = list(family = font)), name = "Very likely thermokarst lake") %>%
       add_trace(r = ~Moderately, line = list(color = "orange", font = list(family = font)), name = "Possibly thermokarst lake") %>%
       add_trace(r = ~Unlikely, line = list(color = "green", font = list(family = font)), name = "Unlikely thermokarst lake") %>%
	   layout(polar = list(radialaxis = list(visible = TRUE, range = c(0, 1.5), tickvals = seq(0, 1.5, by = 0.3),
                                            tickfont = list(family = font, size = 24),tickangle = 0)), 
											showlegend = TRUE, font = list(family = font, size = 26),
											legend = list(font = list(family = font, size = 26)),
											margin = list(l = 80, r = 80, t = 80, b = 80)
											 )

plotly::orca(fig, file = "Thermokarst_lake.png", format = "png", width = 800, height = 600, scale = 5)

