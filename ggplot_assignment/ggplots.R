library(tidyverse)
library(viridis)
library(ggthemes)
library(RColorBrewer)

countries <- read_csv('../data/Countries_merged.csv')
assessments <- read_csv('../data/Assessments_cleaned.csv')
country_goods <- read_csv('../data/CountryGoods.csv')
statistics <- read_csv('../data/Statistics_cleaned.csv')
indicators <- read_csv('../data/HTI00-11.csv')

pdf(file="three_charts.pdf", width=8, height=+ guides(fill=FALSE))

# Bubble Chart
stats_2016 <- filter(statistics, year == 2016)
ggplot(data=stats_2016, aes(x=percent_of_working_children, y=percent_of_children_attending_school)) +
  geom_point(na.rm=TRUE, aes(size=population_of_working_children)) +
  geom_smooth(model = lm) +
  labs(title = "Do working children attend school?",
       subtitle = "Relationship between percent of children working vs attending school in a country in 2016",
       x = "Percent of working children",
       y = "Percent of children attending school",
       size = "Population of working children",
       caption = "Source: United States Department of Labor (DOL), Sweat & Toil Dataset") + 
  theme(plot.title = element_text(size=11)) + 
  scale_x_continuous(labels = scales::percent) + 
  scale_y_continuous(labels = scales::percent) 

# Scatter Plot
countries_stats_2016 = left_join(countries, filter(rename(statistics, "name_DOL" = country), year == 2016), by="name_DOL")

ggplot(data=countries_stats_2016, aes(x=percent_of_working_children, y=net_exports_2015)) +
  geom_point(na.rm=TRUE) +
  geom_smooth(model = lm) + 
  labs(title = "Percent of working children appears unrelated to net exports",
       subtitle = "Relationship between percent of working children vs net exports of a country in 2016",
       x = "Percent of working children",
       y = "Net Exports (% of GDP)",
       caption = "Source: United States Department of Labor (DOL), Sweat & Toil Dataset and World Bank Indicators") + 
  theme(plot.title = element_text(size=11)) + 
  scale_x_continuous(labels = scales::percent) + 
  scale_y_continuous(labels = scales::percent) 
  


# Bar Chart
assessments$year <-factor(assessments$year)

assessments$advancement_level <-factor(assessments$advancement_level)
levels(assessments$advancement_level) <- c("No Advancement", "Minimal Advancement", "Moderate Advancement", "Significant Advancement")
ggplot(data=na.omit(assessments), aes(x=advancement_level, group=year, fill=year)) + 
  geom_bar(na.rm=TRUE, position='dodge') + 
  labs(title = "Most countries struggle to reduce child labor",
       subtitle = "Yearly distribution of assessment of countries' efforts to eliminate the worst forms of child labor ",
       x = "Assessment level",
       y = "Count of countries",
       caption = "Source: United States Department of Labor (DOL), Sweat & Toil Dataset") + 
  theme(plot.title = element_text(size=11)) + 
  scale_fill_brewer()

# Dotplot
country_goods$good = factor(country_goods$good)
country_goods_2015 <- filter(country_goods, year == 2015)
freq_goods <- count(country_goods_2015, good) %>%
  arrange(desc(n)) %>%
  top_n(10)



ggplot(data=subset(country_goods_2015,good %in% freq_goods$good), aes(good)) +
  geom_dotplot(binwidth=0.5, method='histodot', aes(fill=regionname)) + 
  scale_y_continuous(name = "Count of countries", breaks = NULL) + 
  scale_x_discrete(position = 'top') + 
  labs(title = "Gold, sugarcane, bricks, and cotten are the goods most frequently produced by child or forced labor",
       subtitle = "Top ten products produced by child or forced labor in 2015",
       x = "Good",
       fill = "Region Name",
       caption = "Source: United States Department of Labor (DOL), Sweat & Toil Dataset")+
  theme(plot.title = element_text(size=11), axis.text.x = element_text(angle = 45, hjust = 0)) + 
  scale_fill_brewer(drop=TRUE, palette=3, breaks=c('Asia & the Pacific', 'Latin America & the Caribbean', 'Sub-Saharan Africa')) 
  

# Facet grid
ggplot(data=indicators, aes(x=year, y=prosnum, group=1)) +
  geom_line() + 
  facet_wrap(~ country, ncol=8) + 
  theme(axis.text.x=element_blank(),
  axis.ticks.x=element_blank(),
  axis.text.y=element_blank(),
  axis.ticks.y=element_blank(),
  strip.text = element_text(size=9)) +
  labs(title = "Number of people prosecuted for violation of human trafficking laws",
       x = "Year (2002 to 2011)",
       y = "Number of people prosecuted",
       caption = "Source: Human Trafficking Indicators project by Richard W. Frank")


dev.off()
