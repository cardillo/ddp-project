library(shiny)
library(bslib)
library(lubridate)
library(plotly)
library(DT)

shinyUI(page_fluid(
    titlePanel("Constructing yield curves"),
    sidebarLayout(
        sidebarPanel(
            h3("date"),
            dateInput(
                "date",
                "Start date",
                value=floor_date(today() - days(5), 'week') + days(1),
                daysofweekdisabled=c(0, 6)
            )
        ),
        mainPanel(
            h3("Yield Curve (fitted)"),
            plotlyOutput("plot"),
            h3("Yield Curve (points)"),
            dataTableOutput("curve")
        )
    )
))
