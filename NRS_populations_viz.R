library(tidyverse)
library(ckanr)
library(scales)
library(gganimate)

#### DATA ####
ckanr_setup(url = "https://www.opendata.nhs.scot/")

res_est_1974_2006 <- resource_show(id = "5502b69c-5ba2-4b1e-9840-b3b868d6d64b") # pop estimates
res_est_1981_2018 <- resource_show(id = "27a72cc8-d6d8-430c-8b4f-3109a9ceadb1") # pop estimates
res_proj_2018_2043 <- resource_show(id = "7a9e74c9-8746-488b-8fba-0fad7c7866ea") # pop projections

data_est_1974_2006 <- ckan_fetch(x=res_est_1974_2006$url) %>%
  filter(HB1995 == "S92000003") %>%
  select(-starts_with("HB1995"))

data_est_1981_2018 <- ckan_fetch(x=res_est_1981_2018$url) %>%
  filter(HB2014 == "S92000003") %>%
  select(-starts_with("HB2014"))

data_proj_2018_2043 <- ckan_fetch(x=res_proj_2018_2043$url) %>%
  select(-Country)

# combine into one dataset
data <- data_est_1974_2006 %>% filter(Year <= 1980) %>%
  bind_rows(data_est_1981_2018) %>%
  bind_rows(data_proj_2018_2043 %>% filter(Year >= 2019)) %>%
  distinct() %>%
  arrange(Year, Sex)

# reshape into dplyr friendly flat format
df <- data %>%
  select(-AllAges) %>%
  pivot_longer(starts_with("Age"), names_to = "age", values_to = "pop") %>%
  mutate(age = as.integer(str_extract(age, "\\d+"))) %>%
  mutate(birth_year = Year - age)


#### SETUP ####
sky_blue <- rgb(0, 94, 184, maxColorValue = 255)
navy_blue <- rgb(1, 33, 105, maxColorValue = 255)
fps <- 24 # output animation framerate
dpi <- 320 # output resolution
theme_stuff <- theme(axis.text = element_text(size=16, face="bold", colour = navy_blue, family=".SF Compact Text"),
                     axis.title = element_text(size=18, face="bold", colour = navy_blue, family="", lineheight = .5),
                     panel.grid = element_blank(),
                     plot.margin = margin(10, 10, 10, 10, "pt"),
                     panel.border = element_blank(), 
                     axis.line = element_line(colour = navy_blue),
                     legend.text = element_text(size=10, face="bold", colour = navy_blue, family=".SF Compact Text"),
                     legend.title = element_text(size=10, face="bold", colour = navy_blue, family=""))


#### PLOT: age dist ####
x_breaks <- c(20,40,60,80)
y_breaks <- c(25e3, 50e3, 75e3)
title_x <- 5
title_y <- 1e4

year <- 2019

plot_data <- df %>%
  group_by(Year, age) %>%
  summarise(pop = sum(pop, na.rm = TRUE), birth_year = first(birth_year)) %>%
  ungroup()  %>%
  mutate(label = case_when(birth_year==1947 ~ "BOOMERS",
                          birth_year==1965 ~ "GEN-X",
                          birth_year==1989 ~ "GEN-Y",
                          birth_year==2011 ~ "GEN-ALPHA",
                          TRUE ~ NA_character_))

plot_data %>%
  filter(Year == year) %>% 
  ggplot(aes(x = age, y = pop, group=Year)) +
  geom_col(width = 1, fill= sky_blue) +
  scale_x_continuous(breaks = x_breaks, expand = c(0,0)) +
  scale_y_continuous(breaks = y_breaks, expand = c(0,0), labels=comma) +
  geom_text(aes(x=title_x, y=title_y, label=year), size=25, colour="white", hjust="left", 
            family="", fontface="bold") +
  theme_bw() +
  ylab("") +
  xlab("\nage / years") +
  theme_stuff +
  geom_text(aes(x=title_x, y=title_y, label=Year), size=25, colour="white", hjust="left", 
            family="", fontface="bold")

ggsave("plot_age_dist_2019.svg", width=6, height=6, units="in", dpi=dpi, device=svg)
ggsave("plot_age_dist_2019.png", width=6, height=6, units="in", dpi=dpi, device="png", type="cairo")


#### PLOT: age dist animated ####
p <- plot_data %>%
  mutate(x = title_x, y = title_y) %>%
  ggplot(aes(x = age, y = pop, group=Year)) +
  geom_col(alpha = 1, width = 1, fill= sky_blue) +
  scale_x_continuous(breaks = x_breaks, expand = c(0,0)) +
  scale_y_continuous(breaks = y_breaks, expand = c(0,0), labels=comma) +
  theme_bw() +
  ylab("") +
  xlab("\nage / years") +
  theme_stuff +
  transition_time(Year) +
  ease_aes('linear') +
  geom_text(aes(x=title_x, y=title_y, label=Year), size=25, colour="white", hjust="left", 
            family="", fontface="bold") +
  geom_label(data = filter(plot_data, is.na(label)==FALSE), aes(x=age, y=pop, label=label),
             nudge_y = 3e3, colour=navy_blue, family="", fontface="bold", label.size = 1)

animate(p, width = 1920, height = 1920, type="cairo", res=320, fps=fps, duration=10)
anim_save("plot_age_dist_anim.gif")

animate(p, width = 1920, height = 1920, type="cairo", res=320, fps=fps, duration=10, renderer = ffmpeg_renderer())
anim_save("plot_age_dist_anim.mp4")


#### PLOT: carpet1 ####
df %>%
  group_by(Year, age) %>%
  summarise(pop = sum(pop, na.rm = TRUE)) %>%
  ggplot(aes(x = age, y = Year)) +
  geom_tile(aes(alpha=pop), fill=navy_blue) +
  theme_bw() +
  theme_stuff +
  xlab("\nage / years") + ylab("") +
  annotate("blank", x = 40, y = 2055) +  #  hack to add blank space at top
  annotate(geom = "segment", x = 19, y = 2050, xend = 19 , yend = 2044, 
           arrow = arrow(type="closed", length=unit(2, "mm")), colour=navy_blue, size=.2) +
  annotate(geom = "label", x=19, y=2050, label="19 years old",
           colour=navy_blue, family="", fontface="bold", label.size = 1) + 
  scale_x_continuous(breaks = c(20, 40, 60, 80), expand = c(0,0)) +
  scale_y_continuous(breaks = c(1980, 2000, 2020, 2040), expand = c(0,0)) +
  theme(axis.line = element_blank(),
        legend.position = "top") +
  labs(alpha="population") +
  geom_hline(yintercept = 2019, colour="red", size=.2, alpha=.5) +
  scale_alpha_continuous(labels=comma)

ggsave("plot_carpet1.svg", width=6, height=6, units="in", dpi=dpi, device=svg)
ggsave("plot_carpet1.png", width=6, height=6, units="in", dpi=dpi, device="png", type="cairo")


#### PLOT: carpet2 ####
df %>%
  group_by(Year, birth_year) %>%
  summarise(pop = sum(pop, na.rm = TRUE)) %>%
  ggplot(aes(x = birth_year, y = Year)) +
  geom_tile(aes(alpha=pop), fill=navy_blue) +
  theme_bw() +
  theme_stuff +
  xlab("\nbirth year") + ylab("") +
  annotate("blank", x = 2000, y = 2055) +  #  hack to add blank space at top
  annotate(geom = "segment", x = 1918, y = 2050, xend = 1918 , yend = 2010, 
           arrow = arrow(type="closed", length=unit(2, "mm")), colour=navy_blue, size=.2) +
  annotate(geom = "label", x=1918, y=2050, label="WWI",
           colour=navy_blue, family="", fontface="bold", label.size = 1) + 
  annotate(geom = "segment", x = 1945, y = 2050, xend = 1945 , yend = 2037, 
           arrow = arrow(type="closed", length=unit(2, "mm")), colour=navy_blue, size=.2) +
  annotate(geom = "label", x=1945, y=2050, label="WWII",
           colour=navy_blue, family="", fontface="bold", label.size = 1) + 
  scale_x_continuous(breaks = c(1900, 1940, 1980, 2020), expand = c(0,0)) +
  scale_y_continuous(breaks = c(1980, 2000, 2020, 2040), expand = c(0,0)) +
  theme(legend.position = "top") +
  labs(alpha="population") +
  geom_hline(yintercept = 2019, colour="red", size=.2, alpha=.5) +
  scale_alpha_continuous(labels=comma) +
  theme(legend.text = element_text(size=10, face="bold", colour = navy_blue, family=".SF Compact Text"),
        legend.title = element_text(size=10, face="bold", colour = navy_blue, family="")) 

ggsave("plot_carpet2.svg", width=6, height=6, units="in", dpi=dpi, device=svg)
ggsave("plot_carpet2.png", width=6, height=6, units="in", dpi=dpi, device="png")


#### PLOT: 5 year pop evolutions ####
df %>%
  filter(age != 90, birth_year > 1895) %>%  #  remove composite age groups
  group_by(Year, birth_year) %>%
  summarise(pop = sum(pop, na.rm = TRUE)) %>%
  filter(birth_year %% 10 == 0) %>%
  ungroup() %>%
  ggplot(aes(x = Year, y = pop, group=birth_year)) +
  geom_line(aes(colour=as.factor(birth_year)), size=1) +
  scale_y_continuous(breaks = y_breaks, expand = c(0,0), labels=comma) +
  scale_x_continuous(breaks = c(2000, 2040, 1980, 2020), expand = c(0,0)) +
  geom_hline(yintercept = 2019, colour="red", size=.2, alpha=.5) +
  theme_bw() +
  theme_stuff +
  xlab("") + ylab("") + labs(colour="birth year") +
  theme(legend.text = element_text(size=10, face="bold", colour = navy_blue, family=".SF Compact Text"),
        legend.title = element_text(size=10, face="bold", colour = navy_blue, family="")) 

ggsave("plot_5years.svg", width=6, height=6, units="in", dpi=dpi, device=svg)
ggsave("plot_5years.png", width=6, height=6, units="in", dpi=dpi, device="png")


#### PLOT: birth year % animation ####
plot_data <- df %>%
  filter(age != 90, birth_year > 1895) %>%  #  remove composite age groups
  group_by(birth_year, Year) %>%
  summarise(pop = sum(pop, na.rm = TRUE), age=first(age)) %>%
  arrange(birth_year, Year) %>%
  group_by(birth_year) %>%
  mutate(gradient = c(NA, diff(pop))) %>%
  mutate(percent_change = 100 * gradient / lag(pop)) %>%
  mutate(projection = if_else(Year >= 2019, TRUE, FALSE)) %>%
  ungroup() 

p <- plot_data %>%
  ggplot(aes(x = age, y = percent_change, 
             group=interaction(birth_year, projection), 
             colour=projection)) +
  geom_line(aes(linetype=projection), size=2) +
  scale_colour_manual(values = c(navy_blue, "red")) +  
  scale_linetype_manual(values=c("solid", "11")) +
  geom_hline(yintercept = 0, colour=sky_blue, alpha=.5) +
  theme_bw() +
  theme_stuff +
  theme(legend.position = "none") +
  xlab("\nage / years") + ylab("annual change") +
  scale_x_continuous(breaks = c(20, 40, 60, 80), expand = c(0,0)) +
  scale_y_continuous(breaks = c(-15, -10, -5, 0, 5, 10), expand = c(0,0), labels = label_percent(scale=1, accuracy=1)) +
  transition_time(birth_year) +
  ease_aes('linear') +
  geom_text(aes(x=22, y=-15, label=birth_year), size=25, colour=navy_blue, hjust="left", 
            family="", fontface="bold") +
  annotate(geom = "text", x=20, y=-15, label="BIRTH\nYEAR",
           colour=sky_blue, family="", fontface="bold", size = 7.25, hjust="right") 

animate(p, width = 1920, height = 1920, type="cairo", res=320, fps=fps, duration=10)
anim_save("plot_birth_year_change_anim.gif")

animate(p, width = 1920, height = 1920, type="cairo", res=320, fps=fps, duration=10, renderer = ffmpeg_renderer())
anim_save("plot_birth_year_change_anim.mp4")


#### PLOT: unknown pleasures 1 ####
plot_data %>%
  mutate(percent_change = if_else(age==0, 0, percent_change)) %>% # deal with NAs
  # mutate(percent_change = percent_change + birth_year)  %>%
  mutate(y = percent_change + birth_year - 1884 + 6) %>% # shift each line up with birth year
  ggplot(aes(x = age, y = y, group=birth_year,
             colour=projection)) +
  geom_line(alpha=1, linejoin="round", lineend="round") +
  scale_colour_manual(values = c(navy_blue, "red")) +
  scale_x_continuous(breaks = c(0, 20, 40, 60, 80), expand = c(0,0)) +
  scale_y_continuous(expand = c(0,0)) +
  theme_bw() + theme_stuff + xlab("\nage / years") + ylab("") +
  theme(legend.position = "none", 
        axis.ticks.y = element_blank(),
        axis.text.y = element_blank())

ggsave("plot_unknown_pleasures.svg", width=6, height=6, units="in", dpi=dpi, device=svg)
ggsave("plot_unknown_pleasures.png", width=6, height=6, units="in", dpi=dpi, device="png", type="cairo")



#### PLOT: unknown pleasures 2 ####
new_plot_data <- plot_data %>%
  mutate(percent_change = if_else(age==0, 0, percent_change)) %>%
  mutate(y = percent_change + birth_year - 1884 + 6) %>% # shift each line up with birth year
  filter(is.na(y) == FALSE)

# collection of points that define a triangle-ish shape we need to draw to cover up unwanted areas
lower_left_points <- new_plot_data %>%
  group_by(birth_year) %>%
  summarise(age=first(age), y=first(y)) %>% 
  ungroup() %>% 
  select(age, y) %>%
  filter(age > 1)

new_plot_data %>%
  ggplot(aes(x = age, y = y)) +
  geom_area(aes(group=-birth_year), colour="white", fill=navy_blue, alpha=1, position = "identity") +
  geom_area(data = lower_left_points, aes(x=age, y=y), fill=navy_blue, colour=navy_blue, size=2) +
  geom_rect(xmin=0, xmax=89, ymin=0, ymax=165, alpha=0, colour="white", size=1.5) +
  theme_bw() + theme_stuff +
  xlab("") + ylab("") +
  theme(legend.position = "none", 
        panel.background = element_rect(fill=navy_blue),
        axis.text = element_blank(), axis.ticks = element_blank())

ggsave("plot_unknown_pleasures2.svg", width=6, height=6, units="in", dpi=dpi, device=svg)
ggsave("plot_unknown_pleasures2.png", width=6, height=6, units="in", dpi=dpi, device="png", type="cairo")
  
