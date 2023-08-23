library(ggplot2)
library(dplyr)
library(patchwork)

#NDVI/TCG

#
data <- read.csv("D:/Thermokarst.csv")

plot0<- ggplot(data,aes(x=factor(Thermokarst),y=NDVI,fill=Class)) +
	geom_boxplot(alpha=0.5,outlier.alpha=0, size=0.3,width=0.68, color="#555555",position=position_dodge(0.75))+
	scale_fill_manual(values = c("SRVs" = "#84A274","DLBs"="#D19E6C"))+
	stat_summary(fun.y=mean, geom="point", aes(group=factor(Class)),position=position_dodge(0.75), shape=20, size=1.5, color="#555555", fill="#555555") +
	scale_y_continuous(breaks=c(0.2,0.4,0.6,0.8),labels=c("0.2","0.4","0.6","0.8"))+
	coord_cartesian(ylim = c(0.1,0.9))+
    theme(
		axis.ticks=element_line(size = 0.4),axis.ticks.length=unit(.1, "cm"),
		panel.border=element_rect(linetype="solid",fill=NA,size=0.5),
		panel.background=element_blank(),
		axis.title.x=element_text(vjust=1,size=9,color="black"),
		axis.title.y=element_text(vjust=0,size=9,color="black"),
		axis.text.x=element_text(size=9,color="black"), #vjust=1,angle=20,
        axis.text.y=element_text(size=9,color="black"),
		legend.position="none",aspect.ratio=0.8
    ) +
    theme(plot.title=element_text(size=7,color="black",vjust=-0.5,hjust = 0.5))+
	ggtitle(" ") +
	xlab(" ")+ylab(" ")
	
#
data <- read.csv("D:/Lakesize.csv")

plot1<- ggplot(data,aes(x=factor(Lake_Size),y=NDVI,fill=Class)) +
	geom_boxplot(alpha=0.5,outlier.alpha=0, size=0.3,width=0.68, color="#555555",position=position_dodge(0.75))+
	scale_fill_manual(values = c("SRVs" = "#84A274","DLBs"="#D19E6C"))+
	stat_summary(fun.y=mean, geom="point", aes(group=factor(Class)),position=position_dodge(0.75), shape=20, size=1.5, color="#555555", fill="#555555") +
	scale_y_continuous(breaks=c(0.2,0.4,0.6,0.8),labels=c("0.2","0.4","0.6","0.8"))+
	coord_cartesian(ylim = c(0.1,0.9))+
    theme(
		axis.ticks=element_line(size = 0.4),axis.ticks.length=unit(.1, "cm"),
		panel.border=element_rect(linetype="solid",fill=NA,size=0.5),
		panel.background=element_blank(),
		axis.title.x=element_text(vjust=1,size=9,color="black"),
		axis.title.y=element_text(vjust=0,size=9,color="black"),
		axis.text.x=element_text(size=9,color="black"), #vjust=1,angle=20,
        axis.text.y = element_blank(),
		legend.position="none",aspect.ratio=0.8
    ) +
    theme(plot.title=element_text(size=7,color="black",vjust=-0.5,hjust = 0.5))+
	ggtitle(" ") +
	xlab(" ")+ylab(" ")

#
data <- read.csv("D:/Drain_prop.csv")

plot2<- ggplot(data,aes(x=factor(Drain_prop),y=NDVI, fill=Class)) +
	geom_boxplot(alpha=0.5,outlier.alpha=0, size=0.3,width=0.68, color="#555555",position=position_dodge(0.75))+
	scale_fill_manual(values = c("SRVs" = "#84A274","DLBs"="#D19E6C"))+
	stat_summary(fun.y=mean, geom="point", aes(group=factor(Class)),position=position_dodge(0.75), shape=20, size=1.5, color="#555555", fill="#555555") +
	scale_y_continuous(breaks=c(0.2,0.4,0.6,0.8),labels=c("0.2","0.4","0.6","0.8"))+
	coord_cartesian(ylim = c(0.1,0.9))+
    theme(
		axis.ticks=element_line(size = 0.4),axis.ticks.length=unit(.1, "cm"),
		panel.border=element_rect(linetype="solid",fill=NA,size=0.5),
		panel.background=element_blank(),
		axis.title.x=element_text(vjust=1,size=9,color="black"),
		axis.title.y=element_text(vjust=0,size=9,color="black"),
		axis.text.x=element_text(size=9,color="black"), #vjust=1,angle=20,
        axis.text.y = element_blank(),
		legend.position="none",aspect.ratio=0.8
    ) +
    theme(plot.title=element_text(size=7,color="black",vjust=-0.5,hjust = 0.5))+
	ggtitle(" ") +
	xlab(" ")+ylab(" ")


#
data <- read.csv("D:/Region.csv")

plot3<- ggplot(data,aes(x=factor(region),y=NDVI,fill=Class)) +
	geom_boxplot(alpha=0.5,outlier.alpha=0, size=0.3,width=0.68, color="#555555",position=position_dodge(0.75))+
	scale_fill_manual(values = c("SRVs" = "#84A274","DLBs"="#D19E6C"))+
	stat_summary(fun.y=mean, geom="point", aes(group=factor(Class)),position=position_dodge(0.75), shape=20, size=1.5, color="#555555", fill="#555555") +
	scale_y_continuous(breaks=c(0.2,0.4,0.6,0.8),labels=c("0.2","0.4","0.6","0.8"))+
	coord_cartesian(ylim = c(0.1,0.9))+
    theme(
		axis.ticks=element_line(size = 0.4),axis.ticks.length=unit(.1, "cm"),
		panel.border=element_rect(linetype="solid",fill=NA,size=0.5),
		panel.background=element_blank(),
		axis.title.x=element_text(vjust=1,size=9,color="black"),
		axis.title.y=element_text(vjust=0,size=9,color="black"),
		axis.text.x=element_text(size=9,color="black"), #vjust=1,angle=20,
        axis.text.y = element_blank(),
		legend.position="none",aspect.ratio=0.8
    ) +
    theme(plot.title=element_text(size=7,color="black",vjust=-0.5,hjust = 0.5))+
	ggtitle(" ") +
	xlab(" ")+ylab(" ")

#
data <- read.csv("D:/Permafrost.csv")

plot4<- ggplot(data,aes(x=factor(permafrost),y=NDVI,fill=Class)) +
	geom_boxplot(alpha=0.5,outlier.alpha=0, size=0.3,width=0.68, color="#555555",position=position_dodge(0.75))+
	scale_fill_manual(values = c("SRVs" = "#84A274","DLBs"="#D19E6C"))+
	stat_summary(fun.y=mean, geom="point", aes(group=factor(Class)),position=position_dodge(0.75), shape=20, size=1.5, color="#555555", fill="#555555") +
	scale_y_continuous(breaks=c(0.2,0.4,0.6,0.8),labels=c("0.2","0.4","0.6","0.8"))+
	coord_cartesian(ylim = c(0.1,0.9))+
    theme(
		axis.ticks=element_line(size = 0.4),axis.ticks.length=unit(.1, "cm"),
		panel.border=element_rect(linetype="solid",fill=NA,size=0.5),
		panel.background=element_blank(),
		axis.title.x=element_text(vjust=1,size=9,color="black"),
		axis.title.y=element_text(vjust=0,size=9,color="black"),
		axis.text.x=element_text(size=9,color="black"), #vjust=1,angle=20,
        axis.text.y=element_text(size=9,color="black"),
		legend.position="none",aspect.ratio=0.8
    ) +
    theme(plot.title=element_text(size=7,color="black",vjust=-0.5,hjust = 0.5))+
	ggtitle(" ") +
	xlab(" ")+ylab(" ")

#
data <- read.csv("D:/Carbon.csv")

plot5<- ggplot(data,aes(x=factor(carbon),y=NDVI, fill=Class)) +
	geom_boxplot(alpha=0.5,outlier.alpha=0, size=0.3,width=0.68, color="#555555",position=position_dodge(0.75))+
	scale_fill_manual(values = c("SRVs" = "#84A274","DLBs"="#D19E6C"))+
	stat_summary(fun.y=mean, geom="point", aes(group=factor(Class)),position=position_dodge(0.75), shape=20, size=1.5, color="#555555", fill="#555555") +
	scale_y_continuous(breaks=c(0.2,0.4,0.6,0.8),labels=c("0.2","0.4","0.6","0.8"))+
	coord_cartesian(ylim = c(0.1,0.9))+
    theme(
		axis.ticks=element_line(size = 0.4),axis.ticks.length=unit(.1, "cm"),
		panel.border=element_rect(linetype="solid",fill=NA,size=0.5),
		panel.background=element_blank(),
		axis.title.x=element_text(vjust=1,size=9,color="black"),
		axis.title.y=element_text(vjust=0,size=9,color="black"),
		axis.text.x=element_text(size=9,color="black"), #vjust=1,angle=20,
        axis.text.y=element_text(size=9,color="black"),
		legend.position="none",aspect.ratio=0.8
    ) +
    theme(plot.title=element_text(size=7,color="black",vjust=-0.5,hjust = 0.5))+
	ggtitle(" ") +
	xlab(" ")+ylab(" ")

#
data <- read.csv("D:/N.csv")

plot6<- ggplot(data,aes(x=factor(N),y=NDVI, fill=Class)) +
	geom_boxplot(alpha=0.5,outlier.alpha=0, size=0.3,width=0.68, color="#555555",position=position_dodge(0.75))+
	scale_fill_manual(values = c("SRVs" = "#84A274","DLBs"="#D19E6C"))+
	stat_summary(fun.y=mean, geom="point", aes(group=factor(Class)),position=position_dodge(0.75), shape=20, size=1.5, color="#555555", fill="#555555") +
	scale_y_continuous(breaks=c(0.2,0.4,0.6,0.8),labels=c("0.2","0.4","0.6","0.8"))+
	coord_cartesian(ylim = c(0.1,0.9))+
    theme(
		axis.ticks=element_line(size = 0.4),axis.ticks.length=unit(.1, "cm"),
		panel.border=element_rect(linetype="solid",fill=NA,size=0.5),
		panel.background=element_blank(),
		axis.title.x=element_text(vjust=1,size=9,color="black"),
		axis.title.y=element_text(vjust=0,size=9,color="black"),
		axis.text.x=element_text(size=9,color="black"), #vjust=1,angle=20,
        axis.text.y = element_blank(),
		legend.position="none",aspect.ratio=0.8
    ) +
    theme(plot.title=element_text(size=7,color="black",vjust=-0.5,hjust = 0.5))+
	ggtitle(" ") +
	xlab(" ")+ylab(" ")

#
data <- read.csv("D:/Yedoma.csv")

plot7<- ggplot(data,aes(x=factor(yedoma),y=NDVI,fill=Class)) +
	geom_boxplot(alpha=0.5,outlier.alpha=0, size=0.3,width=0.68, color="#555555",position=position_dodge(0.75))+
	scale_fill_manual(values = c("SRVs" = "#84A274","DLBs"="#D19E6C"))+
	stat_summary(fun.y=mean, geom="point", aes(group=factor(Class)),position=position_dodge(0.75), shape=20, size=1.5, color="#555555", fill="#555555") +
	scale_y_continuous(breaks=c(0.2,0.4,0.6,0.8),labels=c("0.2","0.4","0.6","0.8"))+
	coord_cartesian(ylim = c(0.1,0.9))+
    theme(
		axis.ticks=element_line(size = 0.4),axis.ticks.length=unit(.1, "cm"),
		panel.border=element_rect(linetype="solid",fill=NA,size=0.5),
		panel.background=element_blank(),
		axis.title.x=element_text(vjust=1,size=9,color="black"),
		axis.title.y=element_text(vjust=0,size=9,color="black"),
		axis.text.x=element_text(size=9,color="black"), #vjust=1,angle=20,
        axis.text.y = element_blank(),
		legend.position="none",aspect.ratio=0.8
    ) +
    theme(plot.title=element_text(size=7,color="black",vjust=-0.5,hjust = 0.5))+
	ggtitle(" ") +
	xlab(" ")+ylab(" ")


#
data <- read.csv("D:/Flood.csv")

plot8<- ggplot(data,aes(x=factor(flood),y=NDVI,fill=Class)) +
	geom_boxplot(alpha=0.5,outlier.alpha=0, size=0.3,width=0.68, color="#555555",position=position_dodge(0.75))+
	scale_fill_manual(values = c("SRVs" = "#84A274","DLBs"="#D19E6C"))+
	stat_summary(fun.y=mean, geom="point", aes(group=factor(Class)),position=position_dodge(0.75), shape=20, size=1.5, color="#555555", fill="#555555") +
	scale_y_continuous(breaks=c(0.2,0.4,0.6,0.8),labels=c("0.2","0.4","0.6","0.8"))+
	coord_cartesian(ylim = c(0.1,0.9))+
    theme(
		axis.ticks=element_line(size = 0.4),axis.ticks.length=unit(.1, "cm"),
		panel.border=element_rect(linetype="solid",fill=NA,size=0.5),
		panel.background=element_blank(),
		axis.title.x=element_text(vjust=1,size=9,color="black"),
		axis.title.y=element_text(vjust=0,size=9,color="black"),
		axis.text.x=element_text(size=9,color="black"), #vjust=1,angle=20,
		axis.text.y = element_blank(),
		legend.position="none",aspect.ratio=0.8
    ) +
    theme(plot.title=element_text(size=7,color="black",vjust=-0.5,hjust = 0.5))+
	ggtitle(" ") +
	xlab(" ")+ylab(" ")

plot=plot0+plot1+plot2+plot4+plot3+plot8+plot5+plot6+plot7+plot_layout(nrow=3)

ggsave("D:/Merged_NDVI_Boxplot.png", plot, width = 8, height = 6, dpi=1200) 
			  
ggsave("D:/Merged_NDVI_Boxplot.jpg", plot, width = 8, height = 6, dpi=1200) 


