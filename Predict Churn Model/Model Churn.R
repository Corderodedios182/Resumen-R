library(readr)
library(dplyr)
library(ggplot2)

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
ggplot(df_level, aes(x = level, y = turnover_level)) + geom_col() + ggtitle("Indice de Rotración por Puesto")

df_location <- org %>% group_by(location) %>% summarize(turnover_location = mean(turnover))
ggplot(df_location, aes(x = location, y = turnover_location)) + geom_col() + ggtitle("Indice de Rotación por Ubicación")

#Segmentando la muestra por Analyst y Specialist
org %>% count(level)
org2 <- org %>% filter(level %in% c("Analyst", "Specialist")) 
org2 %>% count(level)

#Combinación de datos.
#Cruzando con la calificación de Desempeño.
glimpse(rating)
org3 <- left_join(org2, rating, by = "emp_id")
df_rating <- org3 %>% group_by(rating) %>% summarize(turnover_rating = mean(turnover))
ggplot(df_rating, aes(x = rating, y = turnover_rating)) + geom_col() + ggtitle("Indice de Rotación por calificación de Desempeño.") 

#Cruzando con evaluación de los Gerentes.
glimpse(survey)
org_f <- left_join(org3, survey, by = "mgr_id")
ggplot(org_f, aes(x = status, y = mgr_effectiveness)) + geom_boxplot() + ggtitle("Puntajes de Efectividad Gerenciales Empleados Activos e Inactivos") 

#Base final con 34 variables
glimpse(org_final)
ggplot(org_final, aes(x = status, y = distance_from_home)) + geom_boxplot() + ggtitle("Comparando la distancia al trabajo.")

#-----------------------------#
#Ingeniería de Características#
#-----------------------------#






















