library(tidyverse)

countries <- read_csv('data/Countries_with_WBdata.csv')
assessments <- read_csv('data/Assessments_cleaned.csv')
country_goods <- read_csv('data/CountryGoods.csv')
statistics <- read_csv('data/Statistics_cleaned.csv')

pdf(file="three_charts.pdf", width=8, height=+ guides(fill=FALSE))

# Bubble Chart
stats_2016 <- filter(statistics, year == 2016)
ggplot(data=stats_2016, aes(x=percent_of_working_children, y=percent_of_children_attending_school, size=population_of_working_children)) +
  geom_point(na.rm=TRUE, color="Blue") +
  geom_smooth(model = lm) +
  labs(title = "Countries with higher percentage of working children tend to have lower percentage of children attending school",
       subtitle = "Relationship between percent of children working vs attending school in a country in 2016",
       x = "Percent of working children",
       y = "Percent of children attending school",
       size = "Population of working children") + 
  theme(plot.title = element_text(size=11))

# Bar Chart
assessments$year <-factor(assessments$year)
assessments$advancement_level <-factor(assessments$advancement_level)
levels(assessments$advancement_level) <- c("No Advancement", "Minimal Advancement", "Moderate Advancement", "Significant Advancement")
ggplot(data=na.omit(assessments), aes(x=advancement_level, group=year, fill=year)) + 
  geom_bar(na.rm=TRUE, position='dodge') + 
  labs(title = "Most countries have made little to no advancement in efforts to reduce child labor in the past 3 years",
       subtitle = "Yearly distribution of assessment of countries' efforts to eliminate the worst forms of child labor ",
       x = "Assessment level",
       y = "Count of countries") + 
  theme(plot.title = element_text(size=11))

# Dotplot
country_goods$good = factor(country_goods$good)
country_goods_2015 <- filter(country_goods, year == 2015)
freq_goods <- count(country_goods_2015, good) %>%
  arrange(desc(n)) %>%
  top_n(10)

ggplot(data=subset(country_goods_2015,good %in% freq_goods$good), aes(x = good)) +
  geom_dotplot(dotsize = 1.2, aes(fill=regionname, color=regionname)) + 
  scale_y_continuous(name = "Count of countries where good is made from child or forced labor", breaks = NULL) + 
  scale_x_discrete(position = 'top') + 
  labs(title = "Gold, sugarcane, bricks, and cotten are the goods most frequently produced by child or forced labor",
       subtitle = "Top ten products produced by child or forced labor in 2015",
       x = "Good",
       fill = "Region Name")+
  guides(color=FALSE) + 
  theme(plot.title = element_text(size=11))

dev.off()