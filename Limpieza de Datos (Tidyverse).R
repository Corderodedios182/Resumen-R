library(tidyverse)
glimpse(iris)

#Spread y Gather
wide <- 
  iris %>%
  mutate(row = row_number()) %>%
  gather(vars, val, -Species, -row)

#weather2 <- gather(weather, day, value, X1:X31, na.rm = TRUE)

wide <- spread(wide,vars, val)

#Separar en columnas
wide$Nueva <- paste0('Nueva_',wide$Species)
wide <- separate(wide, col = Nueva, into = c("Nueva","Specie0"), sep = "_") 

#Unir Columnas
wide <- unite(wide, Nueva_Specie0, Nueva, Specie0, sep = "_")

#Orden datos
wide <- arrange(wide,desc(row))

#Aplicar funcion en multiples columnas
iris %>% mutate_each(funs(sum), -Species) %>% head()
iris %>% mutate_each(funs(sum), SLsum = Sepal.Length,SWsum = Sepal.Width,  -Species) %>% head()

#Fechas

library(lubridate)

dmy("17 Sep 2015")

mdy_hm("July 15, 2012 12:56")

ymd("2000-06-05")

ymd_hms("2014-04-10 14:59:54")

#Texto

library(stringri)

str_trim(c("   Filip ", "Nick  ", " Jonathan"))

str_pad(c("23485W", "8823453Q", "994Z"), width = 9, side = "left", pad = "0") #Tener una misma longitud

toupper(letters)

tolower(LETTERS)

str_detect(wide$Species, "setosa")

str_replace(wide$Species, "s", "S")

#Valores Faltantes

wide <- data.frame(Nombre = c("Carlos","Grecia"), Edad = c("25",""))

wide$Edad[wide$Edad == ""] <- NA #Remplazar faltantes por NA
  
is.na(wide)

sum(is.na(wide)) #Suma NA

a <- which(is.na(wide$Edad)) ; wide[a,] #Selecciono solo los valores NA

any(is.na(wide)) #Pregunta si existe un solo NA

summary(wide)

table(summary(wide))

complete.cases(wide) #Con esto vemos que filas no tienen valores perdidos

na.omit(wide) #Nos quedamos con los valores que no tienen elementos NA

#Outliers
summary(iris)

hist(iris$Sepal.Length)
hist(iris$Sepal.Length,right = FALSE) #Carga los ceros a la derecha

boxplot(iris$Sepal.Length)

#Podemos remplazar valores outliers 

a <- which(iris$Sepal.Length >= mean(iris$Sepal.Length))
iris$Sepal.Length[a] <- 10 

iris$Species <- as.character(iris$Species)
iris$Species[iris$Species == "setosa"] <- "SETOSA"






                      