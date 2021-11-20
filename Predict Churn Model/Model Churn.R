library(readr)
library(dplyr)
library(ggplot2)
library(lubridate)

setwd("C:/Users/Maste/Documents/1_Github/Resumen-R/Predict Churn Model")
org <- read_csv("employee_data/org.csv")
rating  <- read_csv("employee_data/rating.csv")
survey  <- read_csv("employee_data/survey.csv")
org_final  <- read_csv("employee_data/org_final.csv")

#---#
#EDA#
#---#

glimpse(org)
org %>% count(status)
org %>% summarize(avg_turnover_rate = mean(turnover))

df_level <- org %>% group_by(level) %>% summarize(turnover_level = mean(turnover))
ggplot(df_level, aes(x = level, y = turnover_level)) + geom_col() + 
  ggtitle("Indice de Rotración por Puesto")

df_location <- org %>% group_by(location) %>% summarize(turnover_location = mean(turnover))
ggplot(df_location, aes(x = location, y = turnover_location)) + geom_col() + 
  ggtitle("Indice de Rotación por Ubicación")

#Segmentando la muestra por Analyst y Specialist
org %>% count(level)
org2 <- org %>% filter(level %in% c("Analyst", "Specialist")) 
org2 %>% count(level)

#Combinación de datos.
#Cruzando con la calificación de Desempeño.
glimpse(rating)
org3 <- left_join(org2, rating, by = "emp_id")
df_rating <- org3 %>% group_by(rating) %>% summarize(turnover_rating = mean(turnover))
ggplot(df_rating, aes(x = rating, y = turnover_rating)) + geom_col() + 
  ggtitle("Indice de Rotación por calificación de Desempeño.") 

#Cruzando con evaluación de los Gerentes.
glimpse(survey)
org_f <- left_join(org3, survey, by = "mgr_id")
ggplot(org_f, aes(x = status, y = mgr_effectiveness)) + geom_boxplot() + 
  ggtitle("Puntajes de Efectividad Gerenciales Empleados Activos e Inactivos") 

#Base final con 34 variables
glimpse(org_final)
ggplot(org_final, aes(x = status, y = distance_from_home)) + geom_boxplot() + 
  ggtitle("Comparando la distancia al trabajo.")

#-----------------------------#
#Ingeniería de Características#
#-----------------------------#
org_final <- org_final %>%
  mutate(date_of_joining = dmy(date_of_joining),
         cutoff_date = dmy(cutoff_date),
         last_working_date = dmy(last_working_date))


emp_age_diff <- org_final %>% mutate(age_diff = mgr_age - emp_age) 
ggplot(emp_age_diff, aes(x = status, y = age_diff)) + geom_boxplot() + 
  ggtitle("Diferencia de Edad entre Empleado y Gerente.",
          subtitle = "La diferencia de edad mediana para los empleados inactivos es ligeramente más alta que para los empleados activos, pero no sabemos si esto es significativo o estadísticamente significativo.")

emp_tenure <- org_final %>%
  mutate(tenure = ifelse(status == "Active", 
                         time_length(interval(date_of_joining, cutoff_date), 
                                     "years"), 
                         time_length(interval(date_of_joining, last_working_date), 
                                     "years")))

ggplot(emp_tenure, aes(x = status, y = tenure)) + geom_boxplot() + 
  ggtitle("Comparación de tiempo de permanencia entre empleados Activos e Inactivos",
          subtitle = "la antigüedad media de los empleados inactivos es menor que la antigüedad de los empleados activos.")
  
ggplot(emp_tenure, aes(x = compensation)) + 
  geom_histogram() + 
  ggtitle("Histograma Salarial")

ggplot(emp_tenure, aes(x = level, y = compensation)) + geom_boxplot() + 
  ggtitle("Salario por tipo de Puesto")

ggplot(emp_tenure, aes(x = level, y = compensation, fill = status)) + geom_boxplot() + 
  ggtitle("Salario por tipo de Puesto Activos e Inactivos",
          subtitle = "¿Notó la variación de la compensación dentro de los niveles de Analista y Especialista?")

#Compa-ratio es una medida única para calcular la competitividad salarial de los empleados.
#La competitividad del salario de cada empleado se puede evaluar mediante Compa-ratio. 
#Las organizaciones utilizan la compensación media para estimar el salario típico para cualquier función / nivel.
#Esta métrica ayuda a la organización a corregir la compensación de los empleados que están muy por debajo de la compensación media.
emp_compa_ratio <- emp_tenure %>%  
  group_by(level) %>%   
  mutate(median_compensation = median(compensation), 
         compa_ratio = compensation / median_compensation)

emp_compa_ratio %>% 
  distinct(level, median_compensation)

#Compa-ratio de más de 1 implica que el empleado recibe una remuneración superior a la mediana, lo que garantiza un salario competitivo.
#Basado en la relación comparativa, calculará compa_levelcomo:
#"Arriba", si la relación de comparación es mayor que 1
#"Abajo", de lo contrario
emp_final <- emp_compa_ratio  %>%  
  mutate(compa_level = ifelse(compa_ratio > 1, "Arriba", "Abajo"))

ggplot(emp_final, aes(x = status, fill = compa_level)) + 
  geom_bar(position = "fill") + 
  ggtitle("Comparacion de Compa-level",
          subtitle = "A una mayor proporción de empleados inactivos se les pagó menos que la compensación media.")
  
#Calcular el valor de la información
#Hasta ahora, ha combinado datos de varias fuentes y ha creado nuevas variables para obtener información a partir de los datos.
#¿Cree que todas estas variables pueden explicar la rotación?
#El valor de la información (IV) ayuda a medir y clasificar las variables sobre la base del poder predictivo de cada variable.
#Puede utilizar Valor de información (IV) para eliminar las variables que tienen un poder predictivo muy bajo.
library(Information)

IV <- create_infotables(data = emp_final, y = "turnover")

IV$Summary















