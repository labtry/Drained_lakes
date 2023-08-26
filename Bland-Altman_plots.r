library(ggplot2)
library(ggpointdensity)
library(viridis)

data <- read.csv("D:/precip_ann.csv")

data$Difference <- data$ERA5L_precip_ann - data$Daymet_precip_ann
t.test(data$Difference)

p <- ggplot(data, aes(x = (ERA5L_precip_ann + Daymet_precip_ann) / 2, y = Difference)) +
	geom_pointdensity(size = 0.1, adjust = 2.5, show.legend = FALSE) +
	scale_color_viridis(limits = c(0, 100), breaks = c(0, 20, 40, 60, 80)) +
	geom_hline(yintercept = mean(data$Difference), color = "#E41A1C") +
	geom_hline(yintercept = mean(data$Difference) + 1.96 * sd(data$Difference), linetype = "dashed", color = "#E41A1C") +
	geom_hline(yintercept = mean(data$Difference) - 1.96 * sd(data$Difference), linetype = "dashed", color = "#E41A1C") +
	theme_classic() +
	labs(title = "", x = "", y = "") +
	theme(
	panel.grid.major = element_blank(),
	panel.grid.minor = element_blank(),
	legend.position = 'none')

ggsave("Ann_precip.png", p, width = 3, height = 2.4,dpi=600) 

################################################################

data <- read.csv("D:/precip_sum.csv")

data$Difference <- data$ERA5L_precip_sum - data$Daymet_precip_sum
t.test(data$Difference)

p <- ggplot(data, aes(x = (ERA5L_precip_sum + Daymet_precip_sum) / 2, y = Difference)) +
	geom_pointdensity(size = 0.1, adjust = 1, show.legend = FALSE) +
	scale_color_viridis(limits = c(0, 100), breaks = c(0, 20, 40, 60, 80)) +
	geom_hline(yintercept = mean(data$Difference), color = "#E41A1C") +
	geom_hline(yintercept = mean(data$Difference) + 1.96 * sd(data$Difference), linetype = "dashed", color = "#E41A1C") +
	geom_hline(yintercept = mean(data$Difference) - 1.96 * sd(data$Difference), linetype = "dashed", color = "#E41A1C") +
	theme_classic() +
	labs(title = "", x = "", y = "") +
	theme(
	panel.grid.major = element_blank(),
	panel.grid.minor = element_blank(),
	legend.position = 'none')

ggsave("Sum_precip.png", p, width = 3, height = 2.4,dpi=600) 


################################################################

data <- read.csv("D:/t2m_ann.csv")

data$Difference <- data$ERA5L_t2m_ann - data$Daymet_t2m_ann
t.test(data$Difference)

p <- ggplot(data, aes(x = (ERA5L_t2m_ann + Daymet_t2m_ann) / 2, y = Difference)) +
	geom_pointdensity(size = 0.1, adjust = 0.05, show.legend = FALSE) +
	scale_color_viridis(limits = c(0, 100), breaks = c(0, 20, 40, 60, 80)) +
	geom_hline(yintercept = mean(data$Difference), color = "#E41A1C") +
	geom_hline(yintercept = mean(data$Difference) + 1.96 * sd(data$Difference), linetype = "dashed", color = "#E41A1C") +
	geom_hline(yintercept = mean(data$Difference) - 1.96 * sd(data$Difference), linetype = "dashed", color = "#E41A1C") +
	theme_classic() +
	labs(title = "", x = "", y = "") +
	theme(
	panel.grid.major = element_blank(),
	panel.grid.minor = element_blank(),
	legend.position = 'none') +
	scale_x_continuous(limits = c(-20, 10)) +
	scale_y_continuous(limits = c(-5.5, 4))

ggsave("Ann_t2m.png", p, width = 3, height = 2.4,dpi=600) 



################################################################

data <- read.csv("D:/t2m_sum.csv")

data$Difference <- data$ERA5L_t2m_sum - data$Daymet_t2m_sum
t.test(data$Difference)

p <- ggplot(data, aes(x = (ERA5L_t2m_sum + Daymet_t2m_sum) / 2, y = Difference)) +
	geom_pointdensity(size = 0.1, adjust = 0.05, show.legend = FALSE) +
	scale_color_viridis(limits = c(0, 100), breaks = c(0, 20, 40, 60, 80)) +
	geom_hline(yintercept = mean(data$Difference), color = "#E41A1C") +
	geom_hline(yintercept = mean(data$Difference) + 1.96 * sd(data$Difference), linetype = "dashed", color = "#E41A1C") +
	geom_hline(yintercept = mean(data$Difference) - 1.96 * sd(data$Difference), linetype = "dashed", color = "#E41A1C") +
	theme_classic() +
	labs(title = "", x = "", y = "") +
	theme(
	panel.grid.major = element_blank(),
	panel.grid.minor = element_blank(),
	legend.position = 'none') +
	scale_x_continuous(limits = c(0, 20)) +
	scale_y_continuous(limits = c(-5.5, 4))

ggsave("Sum_t2m.png", p, width = 3, height = 2.4,dpi=600) 

