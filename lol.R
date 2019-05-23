library(quantmod)
library(tidyquant)
library(timetk)

tq_exchange_options()

tq_index_options()

sp500 <- tq_index("sp500")
glimpse(sp500)

nyse <- tq_exchange('nyse')
glimpse(nyse)

nasdaq <- tq_exchange('nasdaq')
glimpse(nasdaq)
#

stocks.selection <- sp500 %>%
inner_join(rbind(nyse, nasdaq) %>% select(symbol, last.sale.price,
                               market.cap, ipo.year),
           by = c("symbol")) %>%
  filter(ipo.year<2000 & !is.na(market.cap)) %>%
  arrange(desc(weight)) %>%
  slice(1:10)

#
stocks.prices <- stocks.selection$symbol %>%
  tq_get(get = 'stock.prices',
         from = '2000-01-01',
         to = '2018-12-31') %>%
  group_by(symbol)
view(stocks.prices)

index.prices <- "^GSPC" %>%
  tq_get(get = 'stock.prices',
         from = '2000-01-01',
         to = '2018-12-31')
stocks.prices %>% select(symbol, date, adjusted) %>%
  spread(key = symbol, value = adjusted) %>%
  tk_xts(date_var = date)

