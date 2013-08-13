require 'sinatra'
require 'json'
require 'redis'
require 'leaderboard'

redis = Redis.new

highscore_lb = Leaderboard.new('highscores')
highscore_lb.page_size = 10

get '/leaders' do
 content_type :json
 highscore_lb.leaders(1).to_json
end

post '/add' do  
  if params[:nickname] and not params[:nickname].empty?  
    highscore_lb.rank_member(params[:nickname], params[:score])
    status 200
  end
end

# debugging
get '/reset' do
  highscore_lb.delete_leaderboard
end

not_found do  
  halt 404, 'page not found'  
end
