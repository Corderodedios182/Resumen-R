#Condicionales

#Booleanos
TRUE == FALSE
"Hola" == "HoLa"
10 > 5
x <- c(1,4,6) 
y <- c(4,6,1)
x > y
x > 5

#Operadores Logicos

x > 2 & y < 5
x > 2 | y < 5
(10 > 11)
!(10 > 11)

head(mtcars)
#Valores mayores a 21 y cyl == 4
Filtro <- mtcars$mpg > 21 & mtcars$cyl == 4
sum(Filtro)

#Condicionales
x = 10

if (x == 10) {
  print("x es diez")
  }

#else
if (x == 11) {
  print("x es diez")
} else {
  print("x no vale diez")
}

#else if
if (x == 11) {
  print("x vale 11")
} else if (x == 10) {
  print("x vale 10")
} else {
  print("x no vale ni 10 ni 11")
}

#if anhidados
if (x < 20){
  if (x == 10){
    print("Se entro al segundo if")
  }
}

#Todo junto
x <- 20
y <- 30
if (x > 19 & y > 29){
  z <- x + y
} else if (x == 20 & y == 30){
  z <- x - y
} else {
  z <- x / y
}

#While ; Dejara de correr cuando la condicion sea falsa mientras sea verdadera seguira ejecutandose
x <- 64
while (x > 30) {
  x <- x - 7
  print(x)
}

#While, if, else
x <- 64
while (x > 30){
  print(paste("Vamos", x))
  if( x > 48) {
    print("Disminuye 11")
    x <- x - 11
  } else {
    print("Por ultimo solo le quitamos 9")
    x <- x - 9
  }}


#break
x <- 64
while (x > 30){
  print(paste("Nos detenemos por el Break", x))

  if(x > 60){
    break
  }
  
    if( x > 48) {
    print("Disminuye 11")
    x <- x - 11
  } else {
    print("Por ultimo solo le quitamos 9")
    x <- x - 9
  }}

#No importa que el While siga siendo verdadero, se puede cortar con una condicion interna
i <- 1
while (i <= 10) {
  print(3 * i)
  if ( (3 * i) %% 8 == 0) { #Cortamos el while y no iteramos con 10
    break
  }
  i <- i + 1
}
  
#for, bucle para iterar sobre un indicado

for(i in 1:10){
  print(i)
}
  
vector_prueba <- mtcars$cyl  

for(i in 1:length(vector_prueba)){
  print(vector_prueba[i])
}

#for sobre un lista
lista_prueba = list(pop = 150,
                    pais = c("A","B","C","D","E"),
                    capital = FALSE)

lista_prueba

for(i in 1:length(lista_prueba)){
  print(lista_prueba[[i]])
}

#for anhidados
base_prueba  <- data.frame(Columna_1 = c(1,2,3,4),
                           Columna_2 = c("A","B","C","D"))

base_prueba

for(i in 1:nrow(base_prueba)){
  for(j in 1:ncol(base_prueba)){
    print(paste("En la fila", i , "Columna", j , "tenemos el elemanto", base_prueba[i,j]))
  }
}

#for e if
x <- mtcars[1:6,2]

for(i in x){
  if(i == 6){
    print("Vale 6")
  } else {
    print("No vale 6")
  }
  print(i)
}

#for, if, break, next
linkedin <- c(16, 9, 13, 5, 2, 17, 14)

for (li in linkedin) {
  if (li > 10) {
    print("You're popular!")
  } else {
    print("Be more visible!")
  }
  
  # Add if statement with break
  if (li > 16) {
    print("This is ridiculous, I'm outta here!")
    break
  }
  
  # Add if statement with next
  if (li < 5) {
    print("This is too embarrassing!")
    next
  }
  
  print(li)
}

texto <- "Contaremos cuantas r ahi antes de una i"
chars <- strsplit(texto, split =  "")[[1]]

rcount <- 0

for(char in chars){
  if(char == "r"){
    rcount <- rcount + 1
  }
  if(char == "i"){
    break
  }
}

rcount

#Funciones en R; Existen funciones ayudan a simplificar el codigo y funciones que podemos crear nosotros mismos.

#Ejemplo
Suma <- function(x,y){
  x + y
}
#Funcion cread por nosotros
Suma(5,6)

#Funcion predefinida en R
sum(5,6)

Creacion <- function(Numero){
  z <- Numero * 10
  print(paste(Numero,"Multiplicado por 10 da",z))
  return(z)
}

Creacion(5)

#Otras funciones Basicas predefinidas en R.
help(min) 
?min
args(min)

mean(mtcars$cyl)

paste0(mean(mtcars$cyl*10 , trim = .2),"%")

mean(abs(mtcars$cyl), na.rm = FALSE, trim = .2)

#Paqueterias
library(dplyr) #Funciones definidas en Paqueterias

filter(mtcars, cyl == 4)

#Funcion Lapply; Aplica una funcion a multiples elementos, es como aplicar procesos for

pioneers <- c("GAUSS:1777", "BAYES:1702", "PASCAL:1623", "PEARSON:1857")
split_math <- strsplit(pioneers, split = ":") ; split_math
#lapply
split_low <- lapply(split_math, tolower) ; split_low

Personaje <- function(x){
  x[1]
}
#Colocando el nombre de la Funcion Creada
lapply(split_low, Personaje)
#Colocando la sentencia de la funcion
lapply(split_low, function(x) { x[1] } )

Seleccion <- function(x, index){
  x[index]
}
#Funcion con Parametros
lapply(split_low, Seleccion, 1)

#Funcion sapply vs lapply

head(lapply(mtcars, min)) ; sapply(mtcars, min)

Operacion <- function(x){
  (min(x)-max(x))/2
}

sapply(mtcars, Operacion)

#Muliples valores Resumen
Operacion <- function(x){
  c(min = min(x), max = max(x), Promedio = mean(x))
}

sapply(mtcars,Operacion)

vapply(mtcars, Operacion, numeric(3)) #numeric(3) indica que las 3 filas seran numericas

#Seleccion Multiple de condiciones
valores <- function(x){
  return(x[x>21])
}

data.frame(sapply(mtcars, valores)[1])

#Sin sapply tendriamos seleccionar todas las columnas con Condiciones
mtcars$mpg[mtcars$mpg > 21]

vapply(mtcars,function(x,y) { mean(x) > y } , logical(1), y = 10) #logical(1) arroja los valores como logicos
sapply(mtcars, mean)

#Retornando valors Nulos
print_info <- function(x){
  cat("La media es:", mean(x), "\n")
}

sapply(mtcars, print_info)

#Combinacion de Funciones
sapply(mtcars, sum)
abs(sapply(mtcars, sum)) #abs() Valor Absoluto
sum(abs(sapply(mtcars, sum))) 

rev(mtcars$mpg) #Voltea los elementos
mtcars$mpg

A <- list(head(iris$Sepal.Length,5)) ; class(A)
B <- list(head(iris$Sepal.Width,5))

A <- unlist(A) ; class(A)
B <- unlist(B)

length(A) ; length(B)

append(A,B) #Combina los Elementos
length(append(A,B))

sort(append(A,B)) #Ordena los valores
sort(append(A,B), decreasing = TRUE)

seq(1, 7, by = 2) #Crea una secuencia hasta el numero 7, de 2 en 2
rep(seq(1, 7, by = 2), times = 7) #Repite la secuencia 7 veces

seq(1, 100, by = 10)
sum(seq(1 , 100, by = 10))

table(iris$Species) #Conteo de Elementos distintos en una Columna

#Expresiones Regulares
#grep y grepl, Verifican una expresion 
Especies <- iris$Species
#grepl
grepl("se",Especies) #Pregunta si conteiene las letras "se" regresa el valor TRUE O FALSE

Especies[grepl("se", Especies)] #Filtro con las Especies que contienen letras "se"
#grep
grep("se", Especies) #Arroja las filas que contienen la condicion de texto

Especies[grep("se", Especies)]

#Filtros menos especificos
emails <- c("john.doe@ivyleague.edu", "education@world.gov", "dalai.lama@peace.org",
            "invalid.edu", "quant@bigdatacollege.edu", "cookie.monster@sesame.tv")

# Con .* (Coincidir con cualquier caracter, son metacaracteres) , \\.edu$ (Coincidir con la parte .edu)
grepl("@.*\\.edu$", emails)

hits <- grep("@.*\\.edu$", emails)
emails[hits]

#gsub y sub ;Buscan coincidencias y las remplazan

sub("@.*\\.edu$", "@datacamp.edu", emails)

#Fechas
Sys.Date()
unclass(Sys.Date())

Sys.time()

#Para crear un Dateobjeto a partir de una cadena de caracteres simples en R, puede usar la as.Date()función. La cadena de caracteres tiene que obedecer a un formato que se puede definir utilizando un conjunto de símbolos (los ejemplos corresponden al 13 de enero de 1982):
  
#  %Y: Año de 4 dígitos (1982)
#  %y: Año de 2 dígitos (82)
# %m: Mes de 2 dígitos (01)
# %d: Día del mes de 2 dígitos (13)
# %A: día laborable (miércoles)
# %a: día de la semana abreviado (miércoles)
# %B: mes (enero)
# %b: mes abreviado (enero)
#Los siguientes comandos R crearán el mismo Dateobjeto para el día 13 de enero de 1982:

#Importante Conocer el formato de nuestra computadora
str1 <- "Mayo 23, '96"
str2 <- "2012-03-15"
str3 <- "30/Junio/2006"

date1 <- as.Date(str1, format = "%b %d, '%y")
date2 <- as.Date(str2)
date3 <- as.Date(str3, format = "%d/%B/%Y")

format(date1, "%A")
format(date2, "%d")
format(date3, "%b %Y")

#Similar al trabajo con fechas, usar as.POSIXct()para convertir de una cadena de caracteres a un POSIXctobjeto, y format()para convertir de un POSIXctobjeto a una cadena de caracteres. De nuevo, tienes una gran variedad de símbolos:
  
# %H: horas como número decimal (00-23)
# %I: horas como número decimal (01-12)
# %M: minutos como número decimal
# %S: segundos como número decimal
# %T: notación abreviada para el formato típico %H:%M:%S
# %p: Indicador AM / PM

#Para obtener una lista completa de los símbolos de conversión, consulte la strptime documentación en la consola:

?strptime

str1 <- "Mayo 23, '96 hours:23 minutes:01 seconds:45"
str2 <- "2012-3-12 14:23:08"

# Convert the strings to POSIXct objects: time1, time2
time1 <- as.POSIXct(str1, format = "%B %d, '%y hours:%H minutes:%M seconds:%S")
time2 <- as.POSIXct(str2)

# Convert times to formatted strings
format(time1, "%M")
format(time2, "%I:%M %p")

#Operaciones con Fechas
Hoy <- Sys.Date()
Dia <- as.Date("2018-08-01")

Dia - Hoy

Dias <- c(Hoy, Dia)
diff(Dias)

#Los cálculos que usan POSIXct objetos son completamente análogos a los que usan Date objetos.
#Intente experimentar con este código para aumentar o disminuir POSIXct objetos:

now <- Sys.time()
now + 3600          # add an hour
now - 3600 * 24     # subtract a day

birth <- as.POSIXct("1879-03-14 14:37:23")
death <- as.POSIXct("1955-04-18 03:47:12")
einstein <- death - birth
einstein

#Operaciones
astro <- c("20-Marzo-2015", "25-Junio-2015", "23-Septiembre-2015", "22-Diciembre-2015")
astro_dates <- as.Date(astro, format = "%d-%b-%Y")

meteo <- c("Mar 1, 15","Jun 1, 15","Sep 1, 15","Dic 1, 15") #No corre por temas de foramto
meteo_dates <- as.Date(meteo, format= "%B %d, %y")

meteo_dates - astro_dates




