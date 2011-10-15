require 'sinatra'
require 'slim'
require 'twitter'
require 'date'
require 'yahoofinance'


get '/' do  
  load_data
  redirect "/#{rand(@twitter_data.size)}"
end

get '/:id' do
  load_data
  id = params[:id].to_i
  @twitter_status = @twitter_data[id].name
  slim :index
end

def check_cache
  @cache_date ||= Time.now
  # if we've cached the data for more than a day, reload
  if ((Time.now - @cache_date) / 3600) > 1
    @twitter_data = nil
    @market_up = nil
    @cache_date = nil
  end
end

def load_data  
  check_cache
  @twitter_data ||= Twitter.trends_daily.first[1]
  @market_up ||= YahooFinance.get_quotes(YahooFinance::StandardQuote, 'INDU')["^DJI"].changePoints > 0
end