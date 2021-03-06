library(tidyverse)
library(readxl)
library(cowplot)
library(reactable)

#load in base datasets
metro_wage_df <- read_excel("MSA_M2020_dl.xlsx") %>%
  filter(OCC_TITLE == "All Occupations")

description <- read_excel("file_descriptions.xlsx")

nonmetro_wage_df <- read_excel("BOS_M2020_dl.xlsx") %>%
  filter(OCC_TITLE == "All Occupations")

#find median wage groups for each area
h_median_df <- metro_wage_df[,c("AREA","AREA_TITLE","AREA_TYPE","PRIM_STATE","H_MEDIAN")] %>%
  filter(PRIM_STATE != "PR")
h_median_df$H_MEDIAN <- as.numeric(h_median_df$H_MEDIAN)
h_median_df$FIFTY_PERCENT <- h_median_df$H_MEDIAN * 0.5
h_median_df$SIXTY_PERCENT <- h_median_df$H_MEDIAN * 0.6

#number of metro areas where $15 is over the thresholds
h_median_df %>%
  ggplot(mapping=aes(x=(FIFTY_PERCENT <= 15)))+
  geom_bar()

h_median_df %>%
  ggplot(mapping=aes(x=(SIXTY_PERCENT <= 15)))+
  geom_bar()

#adjust for inflation
inflation_proj <- c(0.0174,0.0195,0.0235,0.022,0.022)

h_median_df$ADJ_MEDIAN <- as.vector(h_median_df$H_MEDIAN)

for (p in inflation_proj) {
  h_median_df$ADJ_MEDIAN <- h_median_df$ADJ_MEDIAN + (p * h_median_df$ADJ_MEDIAN)
}

h_median_df$FIFTY_PERCENT_ADJ <- h_median_df$ADJ_MEDIAN * 0.5
h_median_df$SIXTY_PERCENT_ADJ <- h_median_df$ADJ_MEDIAN * 0.6

h_median_df %>%
  ggplot(mapping=aes(x=(FIFTY_PERCENT_ADJ <= 15)))+
  geom_bar()

h_median_df %>%
  ggplot(mapping=aes(x=(SIXTY_PERCENT_ADJ <= 15)))+
  geom_bar()

#find percentage of $15 against median wage for each area
h_median_df$PCT_ADJ <- 15 / h_median_df$ADJ_MEDIAN

#divide into regions

#Census Bureau Regions 
NorthEast <- c("CT", "ME", "MA", "NH", "RI","VT", "NJ", "NY", "PA")
MidWest <- c("IL", "IN", "MI", "OH", "WI","IA", "KS","MN", "MO", "NE", "ND","SD")
South <- c("DE", "FL", "GA", "MD", "NC", "SC", "VA", "DC", "WV", "AL","KY","MS","TN","AR","LA","OK","TX")
West <- c("AZ", "CO", "ID", "MT", "NV", "NM", "UT", "WY", "AK", "CA", "HI", "OR", "WA")
h_median_df$REGION <- ifelse(h_median_df$PRIM_STATE %in% NorthEast, "North East", ifelse(h_median_df$PRIM_STATE %in% MidWest, "Mid West", ifelse(h_median_df$PRIM_STATE %in% West, "West", "South")))

#Bureau of Economic Analysis Regions
NewEngland <-c("CT", "ME", "MA", "NH", "RI","VT")
MidEast <- c("DE","DC","MD", "NJ", "NY", "PA")
GreatLakes <- c("IL", "IN", "MI", "OH", "WI")
Plains <- c("IA", "KS","MN", "MO", "NE", "ND","SD")
Southeast <- c("AL","AR","FL", "GA","KY","LA","MS","NC","SC","TN","VA","WV")
Southwest <- c("AZ","NM","OK","TX")
RockyMount <- c("CO", "ID", "MT","WY")
FarWest <- c("AK","CA","HI","NV","OR","WA")

h_median_df$REGION <- case_when(h_median_df$PRIM_STATE %in% NewEngland ~ "New England",
          h_median_df$PRIM_STATE %in% MidEast ~ "Mid East",
          h_median_df$PRIM_STATE %in% GreatLakes ~ "Great Lakes",
          h_median_df$PRIM_STATE %in% Plains ~ "Plains",
          h_median_df$PRIM_STATE %in% Southeast ~ "Southeast",
          h_median_df$PRIM_STATE %in% Southwest ~ "Southwest",
          h_median_df$PRIM_STATE %in% RockyMount ~ "Rocky Mountains",
          h_median_df$PRIM_STATE %in% FarWest ~ "Far West"
)

cbp2 <- c("#000000", "#E69F00", "#56B4E9", "#009E73",
          "#F0E442", "#0072B2", "#D55E00", "#CC79A7",
          "#9336B9", "#BDBDBD", "#6D5E59", "#84D835")

draw_plot <- function(r) {
  subset(h_median_df, REGION == r) %>%
    ggplot(mapping = aes(y=PCT_ADJ * 100, x=PRIM_STATE)) + 
    geom_point(aes(color=PRIM_STATE), alpha=0.8, size=5) +
    geom_hline(yintercept=60, linetype="dashed", size=1.2) +
    scale_color_manual(values = cbp2) +
    labs(title =sprintf("$15 Wage as Percentage of Median Wage in Metropolitan Areas - %s",r), color="State", x="Metropolitan Areas per State", y="Percantage (%)") +
    theme_minimal_hgrid() +
    theme(axis.text.x = element_blank(), axis.ticks.x = element_blank())
}

draw_plot("Southeast")

draw_plot("New England")

draw_plot("Mid East")

draw_plot("Far West")

draw_plot("Southwest")

draw_plot("Plains")

draw_plot("Rocky Mountains")

#tables

h_median_df$ADJ_MEDIAN <- round(h_median_df$ADJ_MEDIAN, digits = 2)
h_median_df$FIFTY_PERCENT_ADJ <- round(h_median_df$FIFTY_PERCENT_ADJ, digits = 2)
h_median_df$SIXTY_PERCENT_ADJ <- round(h_median_df$SIXTY_PERCENT_ADJ, digits = 2)
h_median_df$FIFTY_PERCENT <- round(h_median_df$FIFTY_PERCENT, digits = 2)
h_median_df$SIXTY_PERCENT <- round(h_median_df$SIXTY_PERCENT, digits = 2)

red_pal <- function(x) rgb(colorRamp(c("#FF4D4D", "#FFCCCC"))(x), maxColorValue = 255)
green_pal <- function(x) rgb(colorRamp(c("#69FF6C", "#CCFFCD"))(x), maxColorValue = 255)

belowh <- h_median_df[h_median_df$ADJ_MEDIAN < 25,]$ADJ_MEDIAN
aboveh <- h_median_df[h_median_df$ADJ_MEDIAN >= 25,]$ADJ_MEDIAN
belowfifty <- h_median_df[h_median_df$FIFTY_PERCENT_ADJ < 15,]$FIFTY_PERCENT_ADJ
abovefifty <- h_median_df[h_median_df$FIFTY_PERCENT_ADJ >= 15,]$FIFTY_PERCENT_ADJ
belowsixty <- h_median_df[h_median_df$SIXTY_PERCENT_ADJ < 15,]$SIXTY_PERCENT_ADJ
abovesixty <- h_median_df[h_median_df$SIXTY_PERCENT_ADJ >= 15,]$SIXTY_PERCENT_ADJ

summarise(h_median_df, AREA_TITLE, 
          ADJ_MEDIAN, FIFTY_PERCENT_ADJ, SIXTY_PERCENT_ADJ) %>%
  reactable(
    style = list(fontFamily = "Work Sans, sans-serif", fontSize = "14px"),
    defaultPageSize = 35,
    columns = list(
      AREA_TITLE = colDef(name = "Area Name"),
      ADJ_MEDIAN = colDef(name = "Adjusted Median Wage",
        style = function(value) {
        ifelse(value >= (25),
        ((max(aboveh)-value) / (max(aboveh) - min(aboveh))) %>%
          green_pal() -> color,
        ((value - min(belowh)) / (max(belowh) - min(belowh))) %>%
          red_pal() -> color
        )
        list(background = color)}),
      FIFTY_PERCENT_ADJ = colDef(name = "50% of Median", style = function(value) {
        ifelse(value >= (15),
               ((max(abovefifty)-value) / (max(abovefifty) - min(abovefifty))) %>%
                 green_pal() -> color,
               ((value - min(belowfifty)) / (max(belowfifty) - min(belowfifty))) %>%
                 red_pal() -> color
        )
        list(background = color)}),
      SIXTY_PERCENT_ADJ = colDef(name = "60% of Median", style = function(value) {
        ifelse(value >= (15),
               ((max(abovesixty)-value) / (max(abovesixty) - min(abovesixty))) %>%
                 green_pal() -> color,
               ((value - min(belowsixty)) / (max(belowsixty) - min(belowsixty))) %>%
                 red_pal() -> color
        )
        list(background = color)})
    ),
    columnGroups = list(
      colGroup(name = "2025 Inflation Adjusted Wages", columns = c("ADJ_MEDIAN", "FIFTY_PERCENT_ADJ", "SIXTY_PERCENT_ADJ"))
    )
  )

#variance 
hourly_median <- h_median_df$ADJ_MEDIAN
var(hourly_median)
sd(hourly_median)

draw_boxplot <- function(r) {
  subset(h_median_df, REGION == r) %>%
    ggplot(mapping = aes(y=PCT_ADJ * 100, x=PRIM_STATE)) + 
    geom_boxplot(aes(color=PRIM_STATE), alpha=0.8, size=1.2) +
    geom_hline(yintercept=60, linetype="dashed", size=1.2) +
    scale_color_manual(values = cbp2) +
    labs(title =sprintf("$15 Wage as Percentage of Median Wage in Metropolitan Areas - %s",r), color="State", x="Metropolitan Areas per State", y="Percantage (%)") +
    theme_minimal_hgrid() +
    theme(axis.text.x = element_blank(), axis.ticks.x = element_blank())
}

draw_boxplot("Southeast")

#calculate minimum wage estimate to each state's average median wage
for (state in unique(h_median_df$PRIM_STATE)) {
  h_median_df[h_median_df$PRIM_STATE == state,]$MIN_ESTIMATE <- median(h_median_df[h_median_df$PRIM_STATE == state,]$SIXTY_PERCENT_ADJ)
}
h_estimate_df <- data.frame(STATE = unique(h_median_df$PRIM_STATE),  )
mean(h_median_df[h_median_df$PRIM_STATE == "AL",]$ADJ_MEDIAN)
median(h_median_df[h_median_df$PRIM_STATE == "AL",]$PCT_ADJ)


h_median_df$MIN_ESTIMATE <- h_median_df$SIXTY_PERCENT_ADJ
median(h_median_df[h_median_df$PRIM_STATE == "AL",]$MIN_ESTIMATE)

draw_plot_estimate <- function(r) {
  subset(h_median_df, REGION == r) %>%
    ggplot(mapping = aes(y=SIXTY_PERCENT_ADJ, x=PRIM_STATE)) + 
    geom_point(aes(color=PRIM_STATE), alpha=0.8, size=5) +
    geom_hline(yintercept=15, linetype="dashed", size=1.2) +
    scale_color_manual(values = cbp2) +
    stat_summary(fun = "mean", fun.min = "mean", fun.max="mean",
                 colour = "red", size = 3, aes(shape="Mean"),geom = "point") +
    guides(colour=guide_legend(order=1), shape=guide_legend(title=NULL, order=2)) +
    labs(title =sprintf("Minimum Wage Proposed Estimates for Each Metropolitan Areas - %s",r), color="State", x="Metropolitan Areas per State", y="Wage ($)") +
    theme_minimal_hgrid() +
    theme(axis.ticks.x = element_blank(), axis.text.x = element_blank() 
          )
}

draw_plot_estimate("Far West")

draw_plot_estimate("Southeast")

draw_plot_estimate("New England")

draw_plot_estimate("Mid East")

draw_plot_estimate("Southwest")

draw_plot_estimate("Plains")

draw_plot_estimate("Rocky Mountains")

#table of estimated min wage per state

min_estimates <- c()

for (state in unique(h_median_df$PRIM_STATE)) {
  min_estimates <- c(min_estimates, mean(h_median_df[h_median_df$PRIM_STATE == state,]$SIXTY_PERCENT_ADJ))
}



state_minimums <- data.frame(STATE = unique(h_median_df$PRIM_STATE), MIN_ESTIMATE = min_estimates)

state_minimums <- rbind(state_minimums, list("National", mean(state_minimums$MIN_ESTIMATE)))

state_minimums %>%
  reactable(style = list(fontFamily = "Work Sans, sans-serif", fontSize = "14px"),
            defaultPageSize = 52,
            columns = list(
              STATE = colDef(name = "State"),
              MIN_ESTIMATE = colDef(name= "Proposed Minimum Wage", cell = function(value){sprintf("$%.2f",value)})
            ))

