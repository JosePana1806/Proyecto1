#Proyecto 1

##Calendar HeatMap

El propósito de este proyecto es desarrollar una aplicación en **Diököl** que represente
un visualizador de datos utilizando una técnica particular de visualización.
Para ello la aplicación permitirá cargar archivos de datos, los presentará y
facilitará la interacción con dicha información.

En este caso desarrollamos un **Calendar HeatMap**, en el cual se muestra a lo largo de un año (calendario normal) diferentes comportamientos de alguna situación en particular. 

Para este trabajo nos basamos en el ejmplo que se encuentra en este link: <https://bl.ocks.org/alansmithy/6fd2625d3ba2b6c9ad48>, el cual está realizado en javascript. Nuestro trabajo consistía en realizar esto mismo, pero en Diököl. 

Este proyecto consta de 3 importantes: Los archivos, la aplicación y la visualización

###Archivos

En la raiz de nuestro proyecto, se encuentra una carpeta denominada **Files**, en donde se encuentran los archivos a utilizar para representar la visualización. Dicho archivo debe estar en formato **.csv** para su correcta integración con la aplicación.

###Aplicación

En el código fuente especificamos cual archivo queremos leer para realizar la visualización. 

![Imagen 1](/assets/imagen3.png "Cargar archivo a leer")



luego simplemente ejecutamos la aplicación.


![Imagen 1](/assets/Imagen2.png "ejecutar Diokol.exe")

y el resultado lucirá a algo similar a esto.

![Imagen 1](/assets/imagen4.png "Resultado")

###Interpretación de la visualización

De acuerdo a esta visualización.

![Imagen 1](/assets/imagen4.png "Resultado")

Observamos los patrones de las averías presentadas en el año 2018 (fecha presente), en donde según el grado de color o la intensidad del color representa una cifra  de las siguientes catalogadas.

Cabe recalcar que la visualización se comporta según los datos del archivo anteriormente citado. Para este caso en concreto se toma hasta la fecha actual (Mayo, 2018).

![Imagen 1](/assets/imagen1.png "categorias")

Cada cuadro del Calendar representa un día del mes, y el color la cantidad de averías reportadas.

###Referencias.
Calendar HeatMap: <https://bl.ocks.org/alansmithy/6fd2625d3ba2b6c9ad48>  
Manual LUA: <https://www.lua.org/manual/5.1/es/>  
Manual Proccesing: <https://processing.org/reference/>

##Créditos

Visualización de información.  
Profesor: Armando Arce.  
Estudiantes: Nelson Rojas y José García.

