#K-Nearest Neighbors (kNN)

library(dplyr) ; library(class)

trafic_signs <- read.csv("C:/Users/Carlos.Flores/Documents/Todo R/Resumen-R/trafic_sign.csv")

head(trafic_signs)

table(trafic_signs$muestra)
dim(trafic_signs)

######################
#Entrenando al Modelo#
######################

#Seleccionamos las 146 de entrenamiento
signs <- trafic_signs %>%
  filter(muestra == 'entrenamiento') %>%
  select(-id,-muestra)

dim(signs)
#Tipo de señales
typo_senal <- signs$typo_senal

#Muestra ejemplo
next_sign <- trafic_signs[206,-c(1,2,3)]

#Funcion knn, nos ayudara a clasificar el vector next_sign
knn(train = signs[-1], test = next_sign, cl = typo_senal)

tail(trafic_signs,1)

#Explorando el DataSet
str(signs)
table(signs$typo_senal)

#Verifique el nivel de rojo promedio de r10 por tipo de signo.
aggregate(r10 ~ typo_senal, data = signs, mean) #Señales de Stop, tendran un promedio de rojo mas alto.

#########################################
#Trabajando con las 59 señales de prueba#
#########################################

table(trafic_signs$muestra)

sign_types <- signs$typo_senal

test_signs <- trafic_signs %>%
  filter(muestra == 'prueba') %>%
  select(-id,-muestra)

#Clasificando las señales de carretera de prueba
signs_pred <- knn(train = signs[-1], test = test_signs[-1], cl = sign_types)
signs_pred
table(signs_pred)

#Creamos una matriz para comparar los valores predichos frente a los reales
signs_actual <- test_signs$typo_senal
table(signs_actual)
table(signs_pred, signs_actual)

#Validando la Exactitud
mean(signs_pred == signs_actual)

dim(test_signs)

##############################
#Teste con otros valores de k#
##############################

# Presicion del modelo con k = 1
k_1 <- knn(train = signs[-1], test = test_signs[-1], cl = sign_types)
mean(signs_actual == k_1)

# Presicion del modelo con k = 7
k_7 <- knn(train = signs[-1], test = test_signs[-1], cl = sign_types, k = 7)
mean(signs_actual == k_7)

#k = 15 
k_15 <- knn(train = signs[-1], test = test_signs[-1], cl = sign_types, k = 15)
mean(signs_actual == k_15)

  #El mejor valor es k = 7

#############################
#Analizando el peso de knn()#
#############################

# Usando el parametro prob = TRUE, obentemos la proporcion de votos para una clase ganadora
sign_pred <- knn(train = signs[-1], test = test_signs[-1], cl = sign_types, k = 7, prob = TRUE)
sign_pred

# Obteniendo el atributo prob de las clases predichas
sign_prob <- attr(sign_pred, "prob")
sign_prob

# Examinando las primeras predicciones
head(sign_pred)

# Examinando la proporcion de los votos ganadores de clase
head(sign_prob)

#Con esto podemos asegurar, la clasiicacion que estamos haciendo


































