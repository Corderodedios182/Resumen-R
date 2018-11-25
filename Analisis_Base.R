library(dplyr) ; library(ggplot2)

datos <- read.csv("prueba1.csv")
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

Doctores_Unicos <- left_join(datos,Doctores_Conteo, by = c("ID_VEEVA"="Conteo.Var1")) %>%
  filter(Conteo.Freq == 1)

#Cruze con Doctores_Conteo y filtro duplicados
Doctores_Repetidos <- left_join(datos,Doctores_Conteo, by = c("ID_VEEVA"="Conteo.Var1")) %>%
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

head(Doctores_Unicos)

colSums(Doctores_Unicos[,5:15])

summary(Doctores_Unicos$categoria)

table(Doctores_Unicos$categoria)
ggplot(Doctores_Unicos, aes(x = categoria)) + geom_bar()
















