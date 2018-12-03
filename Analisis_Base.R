library(dplyr) ; library(ggplot2)

datos <- read.csv('prueba1.csv')
dim(datos)
names(datos)
head(datos)
str(datos)

#¿Doctores Unicos?

Doctores_Conteo <- data.frame(Conteo = unlist(table(datos$ID_VEEVA))) 

Doctores_Repetidos <- Doctores_Conteo %>% 
  filter(Conteo.Freq > 1) %>%
  arrange(desc(Conteo.Freq))

table(Doctores_Repetidos$Conteo.Freq)

Doctores_Unicos <- Doctores_Conteo %>% 
  filter(Conteo.Freq == 1)

Doctores_Unicos <- left_join(datos,Doctores_Conteo, by = c('ID_VEEVA'='Conteo.Var1')) %>%
  filter(Conteo.Freq == 1)

#Cruze con Doctores_Conteo y filtro duplicados
Doctores_Repetidos <- left_join(datos,Doctores_Conteo, by = c('ID_VEEVA'='Conteo.Var1')) %>%
  filter(Conteo.Freq > 1)

table(Doctores_Repetidos$Conteo.Freq)

################
#Revision de NA#
################
colSums(is.na(datos))

colSums(is.na(Doctores_Unicos))

colSums(is.na(Doctores_Repetidos))

#Revision Doctores_Repetidos
head(Doctores_Repetidos) #Tienen doble categoria, ¿Eliminamos duplicados?,¿Con que datos me quedo?

Test <- Doctores_Repetidos %>% 
  filter(Conteo.Freq > 3)
head(Test) #No tienen datos ¿Los eliminamos?

###############################
#Trabajando con Valores Unicos#
###############################

library(rpart.plot) ; library(rpart)

rm(datos, Doctores_Conteo,Doctores_Repetidos, Test, test)

head(Doctores_Unicos)

Suma <- data.frame(unclass(colSums(Doctores_Unicos[,4:13])))

#############################
#Separacion de datos 80 y 20#
#############################

smp_size <- floor(.75 * nrow(Doctores_Unicos))

set.seed(123)
train_ind <- sample(seq_len(nrow(Doctores_Unicos)), size = smp_size)

train <- Doctores_Unicos[train_ind,5:15]
test <- Doctores_Unicos[-train_ind,5:15]

####
#80#
####

dim(train)

example_0 <- train[1,]
example_1 <- borrame[9,]

loan_model <- rpart(CRECSHARE ~ ., data = train, method = "class", control = rpart.control(cp = 0))

example_0
predict(loan_model, example_0, type = "class")
example_1
predict(loan_model, example_1, type = "class")

rpart.plot(loan_model)

train$predict <- predict(loan_model, train, type = "class")

table(train$predict, train$CRECSHARE)

mean(train$predict == train$CRECSHARE)

#######
#Fores#
#######
library(randomForest)

train <- train[,-12]

loan_model <- randomForest(CRECSHARE ~ ., data = train)
train$predict <- predict(loan_model, train, type = "class")
mean(train$predict == train$CRECSHARE)

########
#Prueba#
########

train$predict <- round(train$predict)
mean(train$predict == train$CRECSHARE)

borrame <- filter(train, predict == 1)





























