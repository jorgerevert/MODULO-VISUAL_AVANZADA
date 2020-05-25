#Cargamos las librerias necesarias.
library(shiny)
library(tidyverse)
library(rsconnect)
library(plotly)

#Cargamos desde Github la base de datos que he extraido de Eurostat.

url <- "https://raw.githubusercontent.com/jorgerevert/MODULO-VISUAL_AVANZADA/master/hlth_silc_17_1_Data.csv"
datos <- read_csv(url)

# Procesamos la base de datos, para poder trabajar correctamente la información.
depl
datos$TIME <- as.numeric(as.character(datos$TIME))
datos$Value <- as.numeric(as.character(datos$Value))
datos$GEO <- as.factor(datos$GEO)
datos$INDIC_HE <- as.factor(datos$INDIC_HE)
datos$SEX <- as.factor(datos$SEX)


#Creamos el interface de usurio.

fluidPage(
    #Este comando, permite poder ver la informacion en dispositivos móviles.
    
    HTML('<meta name="viewport" content="width=1024">'),
    
    #Hacemos la parametrizacion correspondiente al tamaño de "sidebar" y el área del gráfico.
    
    tags$head(tags$style(HTML(".col-sm-4 { width: 25%;}
                    .col-sm-8 { width: 75%;}")),
              #Ponemos el titulo general del trabajo realizado
              tags$title("Gráfica EUROSTAT - Datos Esperanza de vida en el seno de la UE")),
    
    
    # Paametrizamos el titulo.
    
    headerPanel(HTML("<b><center>Gráfica EUROSTAT - Datos Esperanza de vida en el seno de la UE</b></center></br>")),
    
    
    
    #Relizmos el tabset y la apariencia para ejecutar en la app de Shiny.
    
    tabsetPanel(type = "tabs",
                
                #Cada "tabpanel" muestra unas entradas especificas para los contenidos tratados
                
                tabPanel("Descripción del Trabajo",
                         mainPanel(
                             h1("Ejercicio Master Big Data -  Módulo Visualización Avanzada", align = "center", style=("color:green")),
                             h2("Jorge Revert Ahumada", align = "center", style=("color:blue")),
                             p(""),
                             h3("Introducción", style=("color:purple")),
                             p("Tras un proceso de búsqueda de información y obtención de datos que podemos encontrar en la pagina de Eurostat, el canal oficial de estadísticas de la Unión Europea. 
                             He querido recoger dentro de mi trabajo es un estudio sobre los datos de la esperanza de vida en cada uno de los países de la Unión Europea, para ello en las dos pestañas siguientes encontraremos sendos gráficos
                             con los que podremos realizar análisis."),
                             p("En el trabajo existen cuatro pestañas, la primera pestaña que es la Descripción del Trabajo, la segunda pestaña corresponde al análisis gráfico lineal,
                               la tercera pestaña corresponde a un análisis gráfico de barras y la cuarta y última pestaña corresponde a las conclusión y referencias"),
                             p(""),
                             p(""),
                             h3("Descripción del Trabajo", style=("color:purple")),
                             p("Como indicaba en la introducción, la base de datos que he trabajado corresponde a la esperanza de vida de los países de la Unión Europea (incluido la media de los países de la Zona). 
                             De la base de datos que he trabajado los datos que hemos utilizado son:"),
                             p(""),
                             p("- Países : Relación de los diferentes países considerados."),
                             p("- Indicadores: En los indicadores existen tres grupos de datos considerados."),
                             p("    •	Esperanza de vida en valores absolutos desde el nacimiento."),
                             p("    •	Esperanza de vida en valores absolutos a partir de 50 años."),
                             p("    •	Esperanza de vida en valores absolutos a partir de 65 años."),
                             p("-	Sexo: Hombres, Mujeres, Ambos."),
                             p("-	Años: Datos disponibles en la base de datos desde el 2004 hasta el 2018."),
                             p("Con todos estos datos he realizado dos análisis gráficos interactivos en los que se pueden ver la evolución y comportamiento de los datos en cada uno de ellos,"),
                             h3("Gráfico de Líneas",style=("color:purple")),
                             p("En el grafico de líneas podemos ver la evolución de la esperanza de vida por años y pudiendo en su caso seleccionar varias variables."),
                             p("Concretamente, en la primera variable que corresponde a países podemos seleccionar los países de los que queramos ver su evolución, 
                               en esta opción podemos incluir tantos países como queramos y asi poder ver la comparativa entre países y años. En el grafico conforme 
                               vamos seleccionando los países a visualizar se van añadiendo los datos delimitando cada país con un color determinado.  A parte de poder
                               seleccionar los paises que queramos podemos cambiar el gráfico viendo uno de los tres indicadores que tenemos en la base de datos, en este
                               caso esperanza de vida en valores absolutos desde el nacimiento, a partir de 50 años y a partir de 65 años.
                               Por ultimo, también se puede seleccionar el sexo para poder observar los datos si son hombres, mujeres o ambos casos."),
                             h3("Gráfico de Barras",style=("color:purple")),
                             p("En esta pestaña de grafico de barras podemos comparar seleccionando varias variables como se comporta la esperanza de vida en cada 
                               uno de los países y podemos de esta forma comparar los datos de todos los países. Como en el grafico de líneas en este grafico podemos 
                               seleccionar varias variables."),
                             p("Concretamente, en la primera variable que corresponde a los años podemos seleccionar como se comportan los datos para un año determinado
                             y de esta forma poder ver la comparativa entre países ya que en el eje de las X aparecen todos los países. Si situamos el cursor en alguna 
                             columna determinada el sistema te mostrará los datos correspondientes. A parte de poder seleccionar un determinado año que queramos podemos
                             cambiar el gráfico viendo uno de los tres indicadores que tenemos en la base de datos, en este caso esperanza de vida en valores absolutos 
                             desde el nacimiento, a partir de 50 años y a partir de 65 años.Por ultimo, también se puede seleccionar el sexo para poder observar los 
                             datos si son hombres, mujeres o ambos casos."),
                             h3("Conclusiones y Referencias",style=("color:purple")),
                             p("En esta ultima pestaña podemos encontrar unas pequeñas conclusiones del trabajo realizado y los gráficos considerados. 
                               Con algún dato relevante que puede llamar la atención."),
                             p("La parte de Referencias únicamente es la parte en la que indico en donde he obtenido la base de datos para realizar el trabajo 
                             y en donde se pueden encontrar dichos datos publicados. Así como también, la dirección en “github” en donde se puede encontrar el trabajo 
                             colgado. Y como no la dirección de shinyapps.io a la que se ha subido."),
                         )),
                tabPanel("Gráfico de Lineas", #Tab Título
                         sidebarLayout( 
                             sidebarPanel(
                                 selectInput(inputId = "GEO",
                                             label = "Seleccionar Paises:",
                                             choices = levels(datos$GEO),
                                             selected = levels(datos$GEO)[1],
                                             multiple = TRUE), #Se permite seleccionar varios países
                                 selectInput(inputId = "INDIC_HE",
                                             label = "Indicador:",
                                             choices = levels(datos$INDIC_HE),
                                             selected = levels(datos$INDIC_HE)[3]),
                                 selectInput(inputId = "SEX",
                                             label = "Sexo:",
                                             choices = levels(datos$SEX),
                                             selected = "Total")),
                             mainPanel(plotlyOutput("lines")))),
                #Realizamos la parte del Gráfico de Barras
                tabPanel("Gráfico de Barras",
                         sidebarLayout(
                             sidebarPanel( selectInput(inputId ="TIME_b", 
                                                       label = "Años",
                                                       choices = c(2004:2018),
                                                       selected = 2010),
                                           selectInput(inputId = "INDIC_HE_b",
                                                       label = "Indicador",
                                                       choices = levels(datos$INDIC_HE),
                                                       selected = levels(datos$INDIC_HE)[3]),
                                           selectInput(inputId = "SEX_b",
                                                       label = "Sexo",
                                                       choices = levels(datos$SEX),
                                                       selected = "Total")),
                             mainPanel(plotlyOutput("bars")))),
                #Última Pestaña Conclusiones y Referencias.
                tabPanel("Conclusiones y Referencias", 
                         h3("Conclusiones.", style=("color:red")),
                         p((" ")),
                         p(("En este ultimo apartado del ejercicio son solo unas líneas de conclusión del ejercicio presentado. En dicho ejercicio mostramos los datos de la esperanza de vida en términos absolutos de los países de Europa.
                            Dichos datos están evaluados tanto por años desde el 2004 hasta el 2018 y a su vez los datos por sexo y varios indicadores.")),
                         p(("Se han realizado dos graficas comparativas para desarrollar los datos comparativos ya sea por países a nivel individual, como selección de países. Por otro lado, se pueden visualizar datos a nivel de sexo,
                            de las mismas comparativas. Siempre también bajo tres tipos de indicadores ya indicados en el desarrollo del trabajo. ")),
                         p(("Las principales conclusiones que podemos desgranar del trabajo se pueden definir según las variables:")),
                         p(("-	Sexo : La evolución es clara de los tres indicadores expuestos en todos ellos la esperanza de vida de las mujeres es mayor 
                            que los hombres. Es un hecho que se demuestra en los datos gráficos expuestos. En los tres indicadores se demuestra dicha afirmación 
                            indicada. Es genética y los datos lo corroboran.")),
                         p(("-	Países: Con respecto a los países podemos ver que la esperanza de vida, como también puede ser lógico va muy ligada al nivel económico que tenga 
                            el país, dado que la misma viene muy relacionada con el gasto sanitario, el cual los países mas ricos generan mayor cuidado de su población. 
                            Por otro lado, cabe destacar que los países del este europeo son los que peores tasas de esperanza de vida existe en los tres indicadores presentados. 
                            Concretamente, los ocho últimos países con menor esperanza de vida son países del este, cuyo nivel de riqueza del país esta por debajo de la media
                            de los países del continente.")),
                         p(("-	Años: Con respecto a la evolución de los años, se puede ver también que los peores años de la crisis económica del año 2008 podemos ver como la evolución
                            de la esperanza de vida  se ve mermada y sufre un ligero retroceso, hecho que demuestra que las crisis económicas merman la calidad del servicio que prestan
                            los países a sus ciudadanos en cuanto a calidad y cuidados de sus ciudadanos viéndose la esperanza de vida afectada")),
                         p(("He realizado un breve análisis de los principales parámetros que he considerado interesante resaltar e intentando no extenderme mucho en las mismas dado 
                            que los datos podemos corroborar hechos lógicos que afectan a la esperanza de vida de los ciudadanos del continente europeo.")),
                         p(""),
                         p(("--------------------------------------------------------------------------------------------------")),
                         h3("Referencias", style=("color:red")),
                         p(("En este ultimo apartado de referencias cabe indicar que lo he dedicado a poner el enlace en donde he sacado los datos del trabajo. La base de datos 
                            esta publicada por la agencia europea EUROSTAT, concretamente la dirección electrónica global de base de datos:")),
                         h5("https://ec.europa.eu/eurostat/data/database", style=("color:blue")),
                         p(("Para los datos tratados deberiamos ir a:")),
                         h5("https://appsso.eurostat.ec.europa.eu/nui/show.do?dataset=hlth_hlye&lang=en", style=("color:blue")),
                )
                
    ))