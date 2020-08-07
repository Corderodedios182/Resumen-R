library(sqldf) #Libreria de R que nos ayuda a introducir codigo SQL en R

#SQL Es un lenguaje de consultas para bases de datos relacionales, muchos administradores de bases de datos (SAS,MYSQL,HADOOP)
#lo ocupan por su facil legibilidad y escritura. Este Script contiene una Introduccion sobre las Estructura basica de las consultas.
#Podra parecer un lenguaje sencillo pero las consultas se pueden tornar dificiles de leer debido a su complejidad.

#######################
#Seleccion de Columnas#
#######################

#Las consultas tienen siempre la misma estructura.

sqldf('SELECT * FROM mtcars') #Indica que requiero todas las columnas de la tabla mtcars

sqldf('SELECT mpg,cyl,disp FROM mtcars') #Especifico que columnas deseo tomar de la tabla mtcars

#Podemos meter funciones que nos permiten mejorar las consultas o ayudar a conocer mejor nuestros datos.

#DISTINCT, COUNT 

sqldf('SELECT DISTINCT vs FROM mtcars') #DISTINCT toma los vales Unicos en una columna

sqldf('SELECT COUNT(*) FROM mtcars') #Cuenta el Numero de Filas

sqldf('SELECT COUNT(DISTINCT vs) FROM mtcars') #Conbinando ambas funciones COUNT y DISTINCT

#WHERE, BETWEEN, AND, WHERE IN, IS NULL, IS NOT NULL (Selecciones generales por medio de condiciones)

sqldf('SELECT * FROM mtcars 
      WHERE mpg > 21')  #WHERE selecciona solo los datos de la columna mpg > 21

sqldf('SELECT * FROM mtcars 
      WHERE mpg > 21 AND am = 1') #AND Me permite colocar mas condiciones sobre los datos que requiero

sqldf('SELECT * FROM mtcars 
      WHERE mpg >= 21 AND mpg <= 26 AND am = 1') #AND Tambien me ayuda a crear rangos de datos sobre una columna

sqldf('SELECT * FROM mtcars 
      WHERE mpg BETWEEN 21 AND 26 AND am = 1') #BETWEEN Es otra forma de crear rangos de datos 

sqldf('SELECT * FROM mtcars
      WHERE mpg IN (21,26,22.8,21.4) AND am = 1') #IN Selecciona multiples datos especificos

mtcars$Nueva <- ifelse(mtcars$am == 1,NA,"CERO") #Codifo R de apoyo para crear valores NA 

sqldf('SELECT * FROM mtcars 
      WHERE Nueva IS NULL') #IS NULL Selecciona solo los valores NA

sqldf('SELECT * FROM mtcars 
      WHERE Nueva IS NOT NULL') #IS NOT NULL Selecciona los valores que no son NA

head(CO2) #Codigo R de apoyo para ver el encabezado de la base CO2 que se encuentra precargada

#LIKE Selecciona por medio de caracteres puede iniciar con una letra, terminar, contener letras, etc.

sqldf("SELECT * FROM CO2      
      WHERE Plant LIKE 'Q%'") #Inicia con Q 

sqldf("SELECT * FROM CO2
      WHERE Plant LIKE '%2' ") #Termina con 2

sqldf("SELECT * FROM CO2
      WHERE Plant LIKE 'Qn_' ") #Contine Qn

sqldf("SELECT * FROM CO2
      WHERE Plant LIKE '_n_' AND Plant LIKE '%2'") #Contiene la letra n en medio y al final el numero 2

sqldf("SELECT * FROM CO2      
      WHERE Plant NOT LIKE 'Q%'") #NO LIKE, No inicia con Q 

#########################    
#Agregacion de Funciones#  
#########################

#En esta seccion veremos Funciones que nos ayudar a conocer mejor los datos de manera desciptiva (SUM, MIN, MAX, AVG). 
#De igual forma podemos crear columnas nuevas operando las ya existentes.

#SUM, MIN, MAX, AVG 

sqldf("SELECT SUM(mpg) FROM mtcars") #Sumamos la columna mpg

sqldf("SELECT SUM(mpg), MIN(mpg), MAX(mpg), AVG(mpg) FROM mtcars") #Calculamos la suma, minimo, maximo y media de la columna mpg

sqldf("SELECT SUM(mpg) FROM mtcars
      WHERE mpg > 21") #Sumamos los valores de mpg que solo sean mayores a 21

sqldf("SELECT SUM(conc), AVG(conc), SUM(uptake), AVG(uptake) FROM CO2
      WHERE Plant LIKE 'Q%' AND uptake > 15") #Suma y media de las columnas conc y uptake, adicional metemos dos condiciones que Plant inicie con Q y uptake se mayor a 15

#En ocaciones necesitamos colocarles un mejor nombre a nuestras estadisticas descriptivas, nos apoyamos de AS

sqldf("SELECT SUM(conc) AS suma_columna_conc ,SUM(uptake) AS suma_columna_uptake FROM CO2
      WHERE Plant LIKE 'Q%' AND uptake > 15") #Despues del AS colocamos el nombre que queramos.

#Operaciones Aritmeticas y con columnas.

sqldf("SELECT 50/20 AS Aritmetica") # multiplicacion (*) , division (/) , resta y suma (-,+), modulo(%)

sqldf("SELECT mpg + cyl  AS Suma_de_columnas FROM mtcars")  #De igual forma podemos operar columnas siempre y cuando sean del mismo tipo

sqldf("SELECT MAX(mpg) - MIN(mpg) AS Diferencia FROM mtcars") #Operando y colocando funciones adicionales

######################################
#Agrupamiento y Ordenamiento de datos# 
######################################  

#Veremos funciones que nos ayudan a agrupar (GROUP BY) y Ordenar(ORDER BY, DESC).

#ORDER BY 
sqldf("SELECT * FROM mtcars 
      WHERE mpg BETWEEN 21 AND 26 
      ORDER BY mpg") #ORDER BY; Ordena los datos de menor a mayor

sqldf("SELECT * FROM mtcars 
      WHERE mpg BETWEEN 21 AND 26 
      ORDER BY mpg DESC") #Si le Agregamos al final DESC los ordena de mayor a menor

#GROUP BY 

sqldf("SELECT cyl, COUNT(*) AS Conteo_cyl FROM mtcars
      GROUP BY cyl")

sqldf("SELECT cyl, COUNT(*) AS Conteo_cyl, MIN(mpg) AS Minimo_del_Grupo FROM mtcars
      GROUP BY cyl")

sqldf("SELECT cyl, COUNT(*) AS Conteo_cyl, SUM(mpg) AS Suma_del_Grupo FROM mtcars
      GROUP BY cyl")

sqldf("SELECT cyl, COUNT(*) AS Conteo_cyl, SUM(mpg) AS Suma_del_Grupo FROM mtcars
      GROUP BY cyl
      ORDER BY Suma_del_Grupo")

sqldf("SELECT cyl, am, COUNT(*) AS Conteo_cyl, SUM(mpg) AS Suma_del_Grupo FROM mtcars
      GROUP BY cyl, am
      ORDER BY cyl, Suma_del_Grupo")

#HAVING y NO WHERE, En un GROUP BY No podemos usar la sentencia WHERE en ese caso usamos HAVING

sqldf("SELECT cyl, COUNT(*) FROM mtcars 
      GROUP BY cyl 
      WHERE mpg > 21") #Nos marcara Error por usar WHERE despues del GROUP BY 

sqldf("SELECT cyl, COUNT(*) FROM mtcars 
      GROUP BY cyl 
      HAVING mpg > 21") #La forma correcta es colocando HAVING

sqldf("SELECT cyl, COUNT(*) FROM mtcars 
      WHERE mpg < 21
      GROUP BY cyl 
      HAVING am = 1
      ORDER BY cyl") #Podemos colocar un WHERE siempre antes del GROUP BY  

#Este Script fue una breve introduccion al Lenguaje SQL para mejorar las consultas y conocer mas funciones dejo los siguientes links.

#Resumen mas ligero de consultas
# http://www.dofactory.com/sql/select-distinct 

#Resumen mas avanzado de consultas
# https://docs.microsoft.com/en-us/sql/t-sql/language-reference



