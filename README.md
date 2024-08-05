# 📈 Análisis y Predicción de Precios de Acciones con Shiny Dashboard

## 🚀 Objetivo

Este proyecto en R utiliza **Shiny Dashboard** para proporcionar una interfaz interactiva para el análisis y la predicción de precios de acciones. Los usuarios pueden seleccionar múltiples tickers de acciones, ver gráficos históricos, realizar predicciones y descargar los datos en formato CSV.

## 🛠️ Funcionalidades

- **Visualización de Datos Históricos**: Muestra los precios históricos de las acciones seleccionadas.
- **Predicción de Precios**: Utiliza el modelo ARIMA para predecir los precios futuros de las acciones.
- **Descarga de Datos**: Permite descargar los datos históricos en formato CSV con un nombre de archivo personalizado.
- **Soporte para Múltiples Acciones**: Analiza y muestra datos para varias acciones al mismo tiempo.

## 📦 Requisitos

- R
- `shiny`
- `shinydashboard`
- `quantmod`
- `forecast`
- `plotly`
- `DT`

Puedes instalar los paquetes necesarios ejecutando el siguiente comando en R:

```r
install.packages(c("shiny", "shinydashboard", "quantmod", "forecast", "plotly", "DT"))
```
