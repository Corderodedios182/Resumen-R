library(gapminder) ; library(tidyverse)

install.packages("gampinder")

help(gapminder)
head(gapminder)

#######################
#Manipulacion de Datos#
#######################

#Funcione filter, mutate, arrange
gapminder_2007 <- gapminder %>%
  filter(year == 2007) %>%
  mutate(gdp = gdpPercap * pop) %>%
  arrange(desc(gdp))

#Resumen de los Datos funcion summarize y group_by

#Calculo de la Mediana Vida Media y Maximo Ingresos percapita del año 1957
gapminder %>%
  filter(year == 1957) %>%
  summarize(medianLifeExp = median(lifeExp),
            maxGdpPercap = max(gdpPercap))

#Resumen por continente y año de la Mediana de Vida Media y Maximo de Ingresos
gapminder %>%
  group_by(continent, year) %>%
  summarize(medianLifeExp = median(lifeExp),
            maxGdpPercap = max(gdpPercap))

########################
#Vizualizacion de datos#
########################

#Comparativo entre Poblacion y Vida Media coloreada por continente
ggplot(gapminder_2007, aes(x = pop, y = lifeExp,color = continent, size = gdpPercap)) +
  geom_point()

#Transformada logaritmica sobre la Poblacion y Vida media, para suavizar los datos
ggplot(gapminder_2007, aes(x = pop, y = lifeExp,color = continent, size = gdpPercap)) +
  geom_point() +
  scale_x_log10() + 
  scale_y_log10()

#Particion de los datos apartir del continente
ggplot(gapminder_2007, aes(x = pop, y = lifeExp,color = continent, size = gdpPercap)) +
  geom_point() +
  scale_x_log10() +
  facet_wrap(~ continent)

#Division por Año y coloreado por Continente, tenemos el ingreso percapita y vida media con un tamaño en la poblacion
ggplot(gapminder, aes(x = gdpPercap, y = lifeExp, color = continent, size = pop)) +
  geom_point() +
  scale_x_log10() +
  facet_wrap(~ year)

##############################
#Manipulacion y Vizualizacion#
##############################

#1#
#Resumen por Año, Vida Media e Ingresos
by_year <- gapminder %>%
  group_by(year) %>%
  summarize(medianLifeExp = median(lifeExp),
            maxGdpPercap = max(gdpPercap))

#Grafico de Vida Media e Ingresos
ggplot(by_year, aes(x = year, y = medianLifeExp)) +
  geom_point() +
  expand_limits(y = 0)

#2#
#Resumen por Continente y Año del Ingreso
by_year_continent <- gapminder %>%
  group_by(continent, year) %>%
  summarize(medianGdpPercap = median(gdpPercap))

#Grafica por Año y Continente sobre los Ingresos
ggplot(by_year_continent, aes(x = year, y = medianGdpPercap, color = continent)) +
  geom_point() +
  geom_line() +
  expand_limits(y = 0)

#3#
#Por Continente Media de Ingresos y Vida Media
by_continent <- gapminder %>%
  group_by(continent) %>%
  summarize(medianGdpPercap = median(gdpPercap),
            medianLifeExp = median(lifeExp))

#Grafico por Continente Media de Ingresos y Vida Media
ggplot(by_continent_2007, aes(x = medianGdpPercap, y = medianLifeExp, color = continent)) +
  geom_col()

#4#
gapminder_1952 <- gapminder %>%
  filter(year == 1952)

ggplot(gapminder_1952, aes(x = pop)) +
  geom_histogram(bins = 30)

ggplot(gapminder_1952, aes(x = pop)) +
  geom_histogram(bins = 30) +
  scale_x_log10()

ggplot(gapminder_1952, aes(x = continent, y = gdpPercap)) +
  geom_boxplot() +
  scale_y_log10() +
  ggtitle("Comparing GDP per capita across continents")