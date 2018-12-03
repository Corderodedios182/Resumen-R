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


###############
#Random Forest#
###############
library(rpart)

smp_size <- floor(.75 * nrow(iris))

set.seed(2018)
train_ind <- sample(seq_len(nrow(iris)), size = smp_size)

train <- iris[train_ind,]
test <- iris[-train_ind,]

####
#80#
####

dim(train)

example_0 <- iris[1,]
example_1 <- iris[112,]

loan_model <- rpart(Species ~ Sepal.Length + Sepal.Width + Petal.Length + Petal.Width, data = train, method = "class", control = rpart.control(cp = 0))

example_0
predict(loan_model, example_0, type = "class")
example_1
predict(loan_model, example_1, type = "class")

#par(mfrow=c(2,2))
#summary(iris$Sepal.Width)
#hist(train$Sepal.Width)
#boxplot(train$Sepal.Width)
#plot(train$Sepal.Width)
rpart.plot(loan_model)

train$predict <- predict(loan_model, train, type = "class")

table(train$predict, train$Species)

mean(train$predict == train$Species)

########
#Podado#
########

loan_model <- rpart(Species ~ Sepal.Width, data = train, method = "class", control = rpart.control(cp = 0, maxdepth = 1)) #Numero maxio de Ramas o Profuncidad del arbol
rpart.plot(loan_model)
train$predict <- predict(loan_model, train, type = "class")
mean(train$predict == train$Species)

loan_model <- rpart(Species ~ Sepal.Width, data = train, method = "class", control = rpart.control(cp = 0, minsplit = 20)) #Numero minimo de observaciones por Nodo
rpart.plot(loan_model)
train$predict <- predict(loan_model, train, type = "class")
mean(train$predict == train$Species)

###############
#Podado Optimo#
###############

plotcp(loan_model)
prune(loan_model, cp = 0)

loan_model <- rpart(Species ~ Sepal.Length + Sepal.Width + Petal.Length + Petal.Width, data = train, method = "class", control = rpart.control(cp = 0, maxdepth = 3)) #Numero maxio de Ramas o Profuncidad del arbol
rpart.plot(loan_model)
train$predict <- predict(loan_model, train, type = "class")
mean(train$predict == train$Species)


########
#Forest#
########

library(randomForest)

train <- train[,-6]

loan_model <- randomForest(Species ~ Sepal.Length + Sepal.Width + Petal.Length + Petal.Width, data = train) #Promedia los resultados
train$predict <- predict(loan_model, train, type = "class")
mean(train$predict == train$Species)


####
#20#
####

library(randomForest)

train <- train[,-6]

loan_model <- randomForest(Species ~ Sepal.Length + Sepal.Width + Petal.Length + Petal.Width, data = train) #Promedia los resultados
test$predict <- predict(loan_model, test, type = "class")
mean(test$predict == test$Species)






