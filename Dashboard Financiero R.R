 library(shiny)
 library(shinydashboard)
 library(quantmod)
 library(forecast)
 library(plotly)
 library(DT)
 
 # Definir la interfaz de usuario
 ui <- dashboardPage(
   dashboardHeader(title = "Análisis y Predicción de Precios de Acciones"),
   dashboardSidebar(
     sidebarMenu(
       menuItem("Dashboard", tabName = "dashboard", icon = icon("dashboard")),
       menuItem("Datos", tabName = "data", icon = icon("table")),
       menuItem("Sobre", tabName = "about", icon = icon("info-circle"))
     ),
     textInput("stock", "Ticker de la Acción", "AAPL"),
     dateRangeInput("dates", "Rango de Fechas", start = "2020-01-01", end = Sys.Date()),
     numericInput("forecastDays", "Días de Predicción:", 30, min = 1)
   ),
   dashboardBody(
     tabItems(
       tabItem(tabName = "dashboard",
               fluidRow(
                 box(plotlyOutput("pricePlot"), title = "Precio Histórico", width = 12),
                 box(plotlyOutput("forecastPlot"), title = "Predicción", width = 12)
               )),
       tabItem(tabName = "data",
               fluidRow(
                 box(DTOutput("dataTable"), title = "Datos Históricos", width = 12),
                 downloadButton("downloadData", "Descargar CSV")
               )),
       tabItem(tabName = "about",
               fluidRow(
                 box(title = "Sobre la Aplicación", width = 12,
                     "Esta aplicación proporciona análisis y predicciones de precios de acciones 
                     utilizando datos históricos y modelos ARIMA.")
               ))
     )
   )
 )
 
 # Definir la lógica del servidor
 server <- function(input, output) {
   # Obtener datos de la acción seleccionada
   stockData <- reactive({
     getSymbols(input$stock, src = "yahoo", from = input$dates[1], to = input$dates[2], auto.assign = FALSE)
   })
   
   # Gráfico del precio histórico
   output$pricePlot <- renderPlotly({
     stockPrices <- stockData()
     p <- ggplot(data = data.frame(Date = index(stockPrices), CoreData = coredata(stockPrices)), 
                 aes(x = Date, y = CoreData)) +
       geom_line(aes(y = Cl(stockPrices)), color = "blue") +
       labs(title = paste("Precio Histórico de", input$stock), x = "Fecha", y = "Precio de Cierre") +
       theme_minimal()
     ggplotly(p)
   })
   
   # Gráfico de predicción
   output$forecastPlot <- renderPlotly({
     stockPrices <- Cl(stockData())
     fit <- auto.arima(stockPrices)
     forecastData <- forecast(fit, h = input$forecastDays)
     
     # Crear un data frame para el gráfico de predicción
     fcastDF <- data.frame(
       Date = c(index(stockPrices), index(stockPrices)[length(stockPrices)] + (1:input$forecastDays)),
       Actual = c(as.numeric(stockPrices), rep(NA, input$forecastDays)),
       Forecast = c(rep(NA, length(stockPrices)), as.numeric(forecastData$mean))
     )
     
     p <- ggplot(fcastDF, aes(x = Date)) +
       geom_line(aes(y = Actual, color = "Actual"), size = 1) +
       geom_line(aes(y = Forecast, color = "Predicción"), size = 1, linetype = "dashed") +
       labs(title = paste("Predicción de Precios de", input$stock), x = "Fecha", y = "Precio") +
       scale_color_manual(values = c("Actual" = "blue", "Predicción" = "red")) +
       theme_minimal()
     ggplotly(p)
   })
   
   # Mostrar datos en tabla
   output$dataTable <- renderDT({
     dat <- stockData()
     dat <- data.frame(Date = index(dat), coredata(dat))
     datatable(dat)
   })
   
   # Descargar datos como CSV
   output$downloadData <- downloadHandler(
     filename = function() {
       paste("Extraction_Analyst_", input$stock, "_", Sys.Date(), ".csv", sep = "")
     },
     content = function(file) {
       dat <- stockData()
       dat <- data.frame(Date = index(dat), coredata(dat))
       write.csv(dat, file, row.names = FALSE)
     }
   )
 }
 
 # Ejecutar la aplicación Shiny Dashboard
 shinyApp(ui = ui, server = server)