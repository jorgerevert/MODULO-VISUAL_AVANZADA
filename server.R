#Cargamos las librerias necesarias.
library(shiny)
library(tidyverse)
library(plotly)
library(rsconnect)
library(wesanderson)

#Cargamos desde Github la base de datos que he extraido de Eurostat.

url <- "https://raw.githubusercontent.com/jorgerevert/MODULO-VISUAL_AVANZADA/master/hlth_silc_17_1_Data.csv"
datos <- read_csv(url)

# Procesamos la base de datos, para poder trabajar correctamente la información.

datos$TIME <- as.numeric(as.character(datos$TIME))
datos$Value <- as.numeric(as.character(datos$Value))
datos$GEO <- as.factor(datos$GEO)
datos$INDIC_HE <- as.factor(datos$INDIC_HE)
datos$SEX <- as.factor(datos$SEX)


#Server function para definir el putput que se debera mostar en la app

function(input, output) {
    
    #Primero Definimos las lineas para los gráficos
    output$lines <- renderPlotly({

        GEOSelected = input$GEO
        INDSelected = input$INDIC_HE
        SEXSelected = input$SEX
        lines_data <- 
            subset(datos, 
                   GEO %in% GEOSelected & 
                       INDIC_HE == INDSelected &
                       SEX== SEXSelected)
        
        #Creamos el output del Gráfico de Lineas
        h1 <- lines_data%>%
            ggplot(aes(x = TIME, y = Value, color = GEO))+
            geom_line(size = 0.8)+
            geom_point(size = 1.8)+
        
            scale_color_manual(values =rev(wes_palette("Darjeeling1", 
                                                       length(unique(lines_data$GEO)), 
                                                       type = "continuous")))+
            
            expand_limits(y = (max(lines_data$Value) + 0.05*max(lines_data$Value)))+
            scale_x_continuous(breaks = seq(min(lines_data$TIME), max(lines_data$TIME), by = 2))+
            labs(title = INDSelected,
                 x = NULL, y = NULL, color = NULL)+ 
            theme_minimal()+
            theme(panel.grid.major.y = element_line(color = "grey87"), 
                  panel.grid.major.x = element_blank(),
                  axis.line.x = element_line(color = "grey87"),
                  axis.ticks.x = element_line(color = "grey40"),
                  plot.title = element_text(size = 16, hjust = 0.5, face = "bold"),
                  axis.text.x = element_text(size = 10, color = "grey40"),
                  axis.text.y = element_text(size = 10, color = "grey40"))
        
        ggplotly(h1, width = 1200, height = 600)%>%
            layout(legend = list(orientation = "h", x = 0.3, y =-0.1))
    }
    )
    
    #Creamos lel output del Gráfico de Barras
    output$bars <- renderPlotly(({
        IBSelected = input$INDIC_HE_b
        TMSelected = input$TIME_b
        SEXBSelected = input$SEX_b
        
        
        bars_data <- subset(datos,                                             
                            INDIC_HE == IBSelected &
                                TIME == TMSelected & 
                                SEX == SEXBSelected)
        
        h2 <- bars_data%>%
            ggplot(aes(x = reorder(GEO, Value), y = Value,
                       text = paste0(GEO, " ", TIME,": ", Value)))+
            geom_bar(stat = "identity", fill = "orange", width = 0.5)+
            expand_limits(y = (max(bars_data$Value) + 0.05*max(bars_data$Value)))+
            labs(title = IBSelected, y = NULL, x = NULL)+
            theme_minimal()+ 
            theme(panel.grid.major.y = element_line(color = "grey87"), 
                  panel.grid.major.x = element_blank(),
                  axis.line.x = element_line(color = "grey87"),
                  axis.ticks.x = element_line(color = "grey40"),
                  plot.title = element_text(size = 16, hjust = 0.5, face = "bold"),
                  axis.text.x = element_text(size = 10, color = "grey40", angle = 45),
                  axis.text.y = element_text(size = 10, color = "grey40"))
        
        ggplotly(h2, tooltip = "text", width = 1200, height = 600)
        
    }))
    
}