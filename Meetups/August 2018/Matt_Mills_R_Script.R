#### Prep

setwd("~/Documents/Presentations/r_users/august_18_meetup")
options(tibble.print_min = 5)
options(tibble.width = Inf)

#### Reading in (tabular) Data: Packages
library(readxl)
excel_file <- readxl::read_xlsx("fantasy_football_draft_prep.xlsx")

#### Summary Data
library(gapminder)
data("gapminder")

mean(gapminder$gdpPercap)
avg_gdp <- mean(gapminder$gdpPercap)

sum(1.0 * gapminder$pop[gapminder$year == 2007])

#### Logical Indexing

my_vec <- c("a", "b", "c", "d")
my_vec == "b"

#### Summarizing Data Extended: dplyr / data.table

library(dplyr)
gapminder %>%
  filter(year == 2007) %>%
  group_by(continent) %>%
  summarize(max_gdp = max(gdpPercap)) %>%
  arrange(desc(max_gdp))

continent_info <- group_by(gapminder, continent) %>%
  summarize(max_gdp = max(gdpPercap),
            mean_pop = mean(pop))
print(continent_info)

#### Joining Data in R

left_join(gapminder, continent_info, by = "continent")

inner_join(gapminder, filter(continent_info, continent == "Americas"), by = "continent")

#### Pivot Tables in R
library(tidyr)

gapminder %>%
  select(country, continent, year, pop) %>%
  spread(key = year, value = pop) %>%
  View

gapminder %>%
  gather(key = "measure", value = "value", lifeExp:gdpPercap)

gapminder %>%
  group_by(continent, year) %>%
  summarize(n = n()) %>%
  spread(continent, n)

#### Plotting in R
library(ggplot2)

ggplot(data = gapminder, aes(x = year, y = gdpPercap, color = continent, group = country)) +
  geom_line()

ggplot(data = gapminder, aes(x = year, y = gdpPercap, color = continent, group = country)) +
  geom_line() +
  facet_wrap(~ continent, nrow = 2) +
  scale_y_log10()

ggplot(data = gapminder, aes(x = year, y = gdpPercap, color = continent, group = country)) +
  geom_line() +
  facet_wrap(~ continent, nrow = 2) +
  scale_y_log10(label = function(x) paste0("$", x / 1000, "k"), name = "GDP Per Capita") +
  scale_color_discrete(guide = F) +
  xlab("") +
  ggtitle("GDP Per Capita Over the Years") +
  theme(strip.background = element_blank(),
        strip.text = element_text(face = "bold"),
        axis.ticks.x = element_blank(),
        axis.text.x = element_text(face = "bold"),
        panel.grid.major.x = element_blank(),
        panel.grid.minor = element_blank(),
        panel.background = element_rect(fill = "black"),
        plot.background = element_rect(fill = "grey80"))

ggplot(data = gapminder, aes(x = year, y = gdpPercap, color = continent, group = country)) +
  geom_line() +
  facet_wrap(~ continent, nrow = 2) +
  scale_y_log10(label = function(x) paste0("$", x / 1000, "k"), name = "GDP Per Capita") +
  scale_color_discrete(guide = F) +
  xlab("") +
  ggtitle("GDP Per Capita Over the Years") +
  theme(strip.background = element_blank(),
        strip.text = element_text(face = "bold"),
        axis.ticks.x = element_blank(),
        axis.text = element_text(face = "bold", color = "#549EF6"),
        panel.grid.major.x = element_blank(),
        panel.grid.minor = element_blank(),
        panel.grid = element_line(color = "#549EF6"),
        panel.background = element_rect(fill = "#1CA93B"),
        plot.background = element_rect(fill = "#F93531"),
        plot.title = element_text(face = "bold"),
        text = element_text(color = "#FFF94F"))
# yellow, green, red, blue

#FFF94F, #1CA93B, #F93531, #549EF6

## other

ggplot(aes(x = x), data = data_frame(x = c(rnorm(1000), rnorm(1000, mean = 6, sd = 3)))) +
  geom_density(fill = "black") +
  geom_vline(xintercept = 3, linetype = "dashed", color = "blue", size = 1.5) +
  geom_vline(xintercept = 10, linetype = "dashed", color = "blue", size = 1.5) +
  xlab("R Experience") +
  ylab("") +
  theme(axis.text = element_blank(),
        axis.ticks = element_blank(),
        panel.grid = element_blank(),
        panel.background = element_rect(fill = "grey80"),
        plot.background = element_rect(fill = "grey80"))
         
