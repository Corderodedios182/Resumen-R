#Paqueterías a usar en el siguiente script
library(gridExtra) ; library(tidyr) ; library(dplyr) ; library(ggplot2) ; library(lubridate) ; library(stringr) ;library(cowplot) ; library(ggthemes) ; library(readxl)

options(repr.plot.width=10, repr.plot.height=8)

#Importación de los datos
Leña_Sur <- data.frame(read_excel("Documentos/Tarea_chile/LeñaSur.xls", sheet = "Datos"))

#1. Conociendo los datos

head(Leña_Sur)

#Nuestro conjunto de datos tienen 5 variables:
#Sector: Sector de ubicación de la vivienda
#Aislacion: Variable categórica que registra si la vivienda posee o no aislación térmica
#Calefactor: Tiempo de uso (o antigüedad) del calefactor.
#Consumo: Cantidad media anual de leña, en metros cúbicos, que consume la vivienda
#Humedad: Nivel de humedad registrada en al leña al momento de visitar la vivienda

dim(Leña_Sur)

#2 Análisis estadístico exploratorio, resumenes numéricos.

#De las cuales 2 son variables categoricas

Leña_Sur %>%
  group_by(Sector) %>%
  summarise(Conteo = n())

Leña_Sur %>%
  group_by(Aislacion) %>%
  summarise(Conteo = n())

a <- Leña_Sur %>%
  group_by(Sector, Aislacion) %>%
  summarise(Conteo = n())

table(Leña_Sur$Sector, Leña_Sur$Aislacion) %>% prop.table() * 100

ggplot(a, aes(x = Aislacion, y = Conteo, size = Conteo)) +
  geom_point(aes(color = Aislacion)) +
  facet_wrap(~Sector) +
  labs(title = 'Conteo de registros por Sector y asilación térmica',subtitle = 'Sector 1: 37% muestra, Sector 2: 33% muestra, Sector 3: 30%')

#3 númericas 

#Objetivo: conocer sobre el consumo de leña
summary(Leña_Sur)
summary(Leña_Sur$Consumo)
  
a <- data.frame(b = unclass(table(round(Leña_Sur$Consumo,digits = 1))))

max(Leña_Sur$Consumo) - min(Leña_Sur$Consumo)
sd(Leña_Sur$Consumo)

sd(Leña_Sur$Consumo)/mean(Leña_Sur$Consumo)

#Distribución del consumo de leña
a <- ggplot(Leña_Sur, aes(x = Consumo)) +
  geom_histogram(bins = 60, fill = "brown") +
  ggtitle("Consumo medio anual de leña (m^3)", subtitle = "Promedio: 19.1, Mediana: 19.3, Moda:9.9, Rango: 34.1, std: 8.7, CV: 45%") +
  geom_vline(aes(xintercept=min(Consumo)), color="blue",linetype="dashed") + 
  geom_vline(aes(xintercept=max(Consumo)), color="blue",linetype="dashed") + 
  geom_vline(aes(xintercept=mean(Consumo)), color="green",linetype="dashed") + 
  geom_vline(aes(xintercept=quantile(Leña_Sur$Consumo)[2]), color="red",linetype="dashed") + 
  geom_vline(aes(xintercept=quantile(Leña_Sur$Consumo)[4]), color="red",linetype="dashed") +
  ggthemes::theme_economist()

summary(Leña_Sur$Calefactor)

b <- ggplot(Leña_Sur, aes(x = Calefactor)) +
  geom_histogram(bins = 60, fill = "red") +
  ggtitle("Tiempo de uso Calefactor (años).", subtitle = "Promedio: 13.4, Mediana: 15, Moda: 18.9, Rango: 34.1, std: 6.3, CV: 46.5%") +
  geom_vline(aes(xintercept=min(Calefactor)), color="blue",linetype="dashed") + 
  geom_vline(aes(xintercept=max(Calefactor)), color="blue",linetype="dashed") + 
  geom_vline(aes(xintercept=mean(Calefactor)), color="green",linetype="dashed") + 
  geom_vline(aes(xintercept=quantile(Leña_Sur$Calefactor)[2]), color="red",linetype="dashed") + 
  geom_vline(aes(xintercept=quantile(Leña_Sur$Calefactor)[4]), color="red",linetype="dashed") + 
  ggthemes::theme_economist()

summary(Leña_Sur$Humedad)

c <- ggplot(Leña_Sur, aes(x = Humedad)) +
  geom_histogram(bins = 60, fill = "blue") +
  ggtitle("Porcentaje de humedad en la leña.", subtitle = "Promedio: 15.6, Mediana: 15.9, Moda: 16.4, Rango: 16.4, std: 3.3, CV: 21%") +
  geom_vline(aes(xintercept=min(Humedad)), color="blue",linetype="dashed") + 
  geom_vline(aes(xintercept=max(Humedad)), color="blue",linetype="dashed") + 
  geom_vline(aes(xintercept=mean(Humedad)), color="green",linetype="dashed") + 
  geom_vline(aes(xintercept=quantile(Leña_Sur$Humedad)[2]), color="red",linetype="dashed") + 
  geom_vline(aes(xintercept=quantile(Leña_Sur$Humedad)[4]), color="red",linetype="dashed") +
  ggthemes::theme_economist()

list(grid.arrange(a, b , c, nrow = 2, ncol = 2, as.table = TRUE))

#Box plot

a <- ggplot(Leña_Sur, aes(x = "", y = Consumo), color = dose) +
  geom_boxplot(color = "brown") +
  ggtitle("Box-plot; consumo de leña promedio 19,6 metros cúbicos") +
  ggthemes::theme_economist()

b <- ggplot(Leña_Sur, aes(x = "", y = Calefactor), color = dose) +
  geom_boxplot(color = "red") +
  ggtitle("Calefactor tiempo de uso promedio 13 años") +
  ggthemes::theme_economist()

c <- ggplot(Leña_Sur, aes(x = "", y = Humedad), color = dose) +
  geom_boxplot(color = "blue")  +
  ggtitle("Humedad en la leña promedio 15%") +
  ggthemes::theme_economist()

list(grid.arrange(a, b , c, nrow = 2, ncol = 2, as.table = TRUE))

#Distribución acumulada, medidas de  tendencia central y dispersión.

#Tendencia central: Promedio, Mediana, Moda
#Medidas de dispersión: Rango de variación, Desviación estándar, Coeficiente de variación, 

#¿Consumo de leña, por sector y aislación térmica?

a <- Leña_Sur %>%
  group_by(Sector, Aislacion) %>%
  summarise(Conteo = n())

ggplot(Leña_Sur, aes(x = Aislacion, y = Consumo)) +
  geom_point(aes(color = Aislacion)) +
  facet_wrap(~Sector) +
  labs(title = 'Consumo de leña por sector',subtitle = 'Sector 2 tienen el mayor consumo de leña, interesante ver si no se cuenta con aislación térmica el consumo de leña es mayor.') +

#¿El tiempo de uso del calefactor afecta el consumo?
cor(Leña_Sur$Calefactor, Leña_Sur$Consumo, method = "pearson")

ggplot(Leña_Sur, aes(x = Humedad, y = Consumo)) +
  geom_point(aes(color = Aislacion)) +
  labs(title = 'Humedad y Consumo de leña',
       subtitle = 'Coeficiente de correlación: -.78 correlación negativa.')

ggplot(Leña_Sur, aes(x = Calefactor, y = Consumo)) +
  geom_point(aes(color = Aislacion)) +
  facet_wrap(~Sector) +
  labs(title = 'Años del Calefactor y Consumo de leña',subtitle = 'Wow!! de vista parece entre más años el calefactor mayor es el consumo.')


#¿La humedad afecta el consumo?

ggplot(Leña_Sur, aes(x = Humedad, y = Consumo, color = Calefactor)) +
  geom_point() +
  facet_wrap(~Sector) +
  labs(title = 'Tener un adecuado porcentaje de humedad y menor tiempo de vida del calefactor favorece el consumo.',subtitle = 'Wow!! Enfoquemos la vista en el sector 1 y 2, nubes de puntos con menor consumo. ')
  


#Todo junto, el consumo de leña es mayor o menor dependiendo de la humedad y uso del calefactor, ayuda el asilamiento termico

#Correlación entre variables.

#Necesitamos mayor información para decir más sobre el consumo de leña, Temperatura, usos de la leña.

#INFERENCIA ESTADÍSTICA




