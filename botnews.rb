require 'sinatra'
require 'slim'
require 'twitter'
require 'date'
require 'yahoofinance'


get '/' do  
  check_cache
  @twitter_status ||= Twitter.trends_daily.first[1]
  @market_up = YahooFinance.get_quotes(YahooFinance::StandardQuote, 'INDU')["^DJI"].changePoints > 0
  slim :index
end

def check_cache
  @cache_date ||= Time.now
  # if we've cached the data for more than a day, reload
  if ((Time.now - @cache_date) / 3600) > 24
    @twitter_status = nil
    @market_up = nil
    @cache_date = nil
  end
end