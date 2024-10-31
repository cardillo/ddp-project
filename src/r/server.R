library(shiny)
library(lubridate)
library(tidyverse)
library(tidyquant)
library(timetk)
library(ggplot2)
library(plotly)
library(DT)

shinyServer(function(input, output) {
    df <- reactive( {
        start <- input$date
        df <- tibble(
            date=c(
                start,
                start %m+% months(1),
                start %m+% months(3),
                start %m+% months(6),
                start + years(1),
                start + years(2),
                start + years(3),
                start + years(5),
                start + years(7),
                start + years(10),
                start + years(20),
                start + years(30)
            ),
            symbol=c(
                'EFFR',
                'DGS1MO',
                'DGS3MO',
                'DGS6MO',
                'DGS1',
                'DGS2',
                'DGS3',
                'DGS5',
                'DGS7',
                'DGS10',
                'DGS20',
                'DGS30'
            )
        )

        get_rate <- function(sym) {
            r <- tq_get(sym, 'economic.data', from=start-days(1), to=start)
            last(r$price)
        }

        df %>% mutate(rate=map_dbl(symbol, get_rate))
    })

    output$plot <- renderPlotly({
        ts <- df() %>% tk_xts(silent=TRUE) %>% tk_tbl(rename_index='date')
        ts %>%
            ggplot(aes(date, rate)) +
            geom_point() +
            stat_function(
                fun=splinefun(ts$date, ts$rate),
                linewidth=1,
                color='blue'
            )
    })
    output$curve <- renderDataTable({
        datatable(
            df(),
            rownames=FALSE,
            selection='single',
            options=list(dom='t')
        )
    })
})
