# https://www.alphavantage.co/documentation/

api_key=YMKEPIY3AWI2CV5G
symbol=MSFT
interval=5min # 1min, 5min, 15min, 30min, 60min

### Stock time series - intraday
# returns intraday time series (timestamp, open, high, low, close, volume) of the equity specified, updated realtime.
curl "https://www.alphavantage.co/query?function=TIME_SERIES_INTRADAY&symbol=$symbol&interval=$interval&apikey=$api_key"
# curl "https://www.alphavantage.co/query?function=TIME_SERIES_INTRADAY&symbol=$symbol&interval=$invertal&outputsize=full&apikey=$api_key"

#Downloadable CSV file
# curl "https://www.alphavantage.co/query?function=TIME_SERIES_INTRADAY&symbol=$symbol&interval=$interval&apikey=$api_key&datatype=csv"


### Stock time series - daily
# returns daily time series (date, daily open, daily high, daily low, daily close, daily volume) of the equity specified
curl "https://www.alphavantage.co/query?function=TIME_SERIES_DAILY&symbol=$symbol&interval=$interval&apikey=$api_key"

### Stock time series - daily adjusted
# returns daily time series (date, daily open, daily high, daily low, daily close, daily volume, daily adjusted close, and split/dividend events) of the equity specified
curl "https://www.alphavantage.co/query?function=TIME_SERIES_DAILY_ADJUSTED&symbol=$symbol&interval=$interval&apikey=$api_key"

### Stock time series - other frequencies
# function=TIME_SERIES_WEEKLY
# function=TIME_SERIES_WEEKLY_ADJUSTED 
# function=TIME_SERIES_MONTHLY 
# function=TIME_SERIES_MONTHLY_ADJUSTED 


### Foreign Exchange (FX) - currency exchange rate
# returns the realtime exchange rate for any pair of digital currency (e.g., Bitcoin) or physical currency (e.g., USD)
# Bitcoin to Chinese Yuan: 
curl "https://www.alphavantage.co/query?function=CURRENCY_EXCHANGE_RATE&from_currency=BTC&to_currency=CNY&apikey=$api_key"

# US Dollar to Japanese Yen: 
curl "https://www.alphavantage.co/query?function=CURRENCY_EXCHANGE_RATE&from_currency=USD&to_currency=JPY&apikey=$api_key"


### Digital & Crypto Currencies - digital-currency-intraday
# returns the realtime intraday time series (in 5-minute intervals) for any digital currency (e.g., BTC) traded on a specific market (e.g., CNY/Chinese Yuan). 
# Prices and volumes are quoted in both the market-specific currency and USD. 

curl "https://www.alphavantage.co/query?function=DIGITAL_CURRENCY_INTRADAY&symbol=BTC&market=CNY&apikey=$api_key"

### Digital & Crypto Currencies - other frequencies
# function=DIGITAL_CURRENCY_DAILY 
# function=DIGITAL_CURRENCY_WEEKLY 
# function=DIGITAL_CURRENCY_MONTHLY 


### Stock Technical Indicators
# we may not need this and skip the example


### Sector
# returns the realtime and historical sector performances calculated from S&P500 incumbents
# 10 sectors
curl "https://www.alphavantage.co/query?function=SECTOR&apikey=$api_key"