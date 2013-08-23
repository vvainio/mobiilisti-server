require 'sinatra'
require 'json'
require 'redis'
require 'leaderboard'

redis = Redis.new

highscore_lb = Leaderboard.new('highscores')
highscore_lb.page_size = 10

get '/leaders' do
  begin
    content_type :json
    highscore_lb.leaders(1).to_json
  rescue
    status 500
  end 
end

get '/aroundme' do
  if params[:nickname] and not params[:nickname].empty?
    begin
      content_type :json
      nickname = params[:nickname].strip
      highscore_lb.around_me(nickname, page_size: 5).to_json
    rescue
      status 500
    end
  end
end

post '/add' do  
  if params[:nickname] and not params[:nickname].empty?
    if params[:score] and not params[:score].empty?
      begin
        nickname = params[:nickname].strip
        score = params[:score].to_i
        
        highscore_check = lambda do |member, current_score, score, member_data, leaderboard_options|
          return true if current_score.nil?
          return true if score > current_score
          false
        end

        highscore_lb.rank_member_if(highscore_check, nickname, score)
        status 200
      rescue
        status 500
      end
    end
  end
end

not_found do  
  halt 404, 'page not found'  
end