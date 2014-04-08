require_relative './lib/moodeo.rb'
require 'sinatra'
require 'rubygems'
require 'pry-debugger'

Moodeo.db_name = 'moodeo.db'

set :bind, '0.0.0.0'
enable :sessions

get '/' do
  erb :home
end

get '/signin' do
  erb :signin
end


post '/signin' do
  puts params
  puts "at post signin"
  puts session[:username]

  result = Moodeo::SignIn.run(:username => params[:username], :password => params[:password])
  if result.success?
    puts "Success: #{result.inspect}"
    puts "Params: #{params[:username]}::#{params.inspect}"
    session[:username] = params[:username]
    puts "Session 1: #{session.inspect}"
    redirect '/main'
  else
    if result.error == :invalid_username
      @message = "Sorry, username is not found"
    end
    if result.error == :invalid_password
      @message = "Sorry, password is not correct. Try again"
    end
      puts @message
      erb :signin
  end

  puts "session username at post signin"
  puts session[:username]

end

get '/main' do
  puts 'at get main'
  puts "this is session username: "
  puts session[:username]
  puts "Session 2: #{session.inspect}"

  # Redirect to sign in page if user is not signed in
  if session[:username] == nil
    redirect '/signin'
  end

  @username = session[:username]

  usernameforsearch = Moodeo.db.get_user_by_username(@username)
  puts usernameforsearch

  @invites = Moodeo.db.get_all_friend_requests_by_user_id(usernameforsearch.id)
  # @invites_count = @invites.count
  erb :main
end

get '/signup' do
  erb :signup
end

post '/signup' do
  @name = params[:name]
  @username = params[:username]
  @password = params[:password]
  result = Moodeo::SignUp.run(:name => @name, :username => @username, :password => @password)
  if result.success?
    erb :signin
  else
    if result.error == :username_taken
      @message = "Sorry, that username is taken"
    end
    if result.error == :weak_password
      @message = "Sorry, that password is weak sauce."
    end
      puts @message
      erb :signup
  end
end

post '/search' do
  search = params[:search_for_user]
  usernameforsearch = Moodeo.db.get_user_by_username(search)
  if usernameforsearch != nil
    @userfound = usernameforsearch.username
    erb :search
  else
    @userfound = "Sorry, User was not found"
    erb :search
  end
end

get '/profile/:username' do
  usernameforsearch = Moodeo.db.get_user_by_username(params[:username])
  if usernameforsearch != nil
    @userfound_username = usernameforsearch.username
    @userfound_name = usernameforsearch.name
    erb :profile
  else
    @userfound = "Sorry, User was not found"
    erb :profile
  end
end


get '/addfriend/:user2' do
  usernameforsearch = Moodeo.db.get_user_by_username(params[:user2])
  ourusername = Moodeo.db.get_user_by_username(@@username)
  if usernameforsearch != nil
    request = Moodeo.db.friend_request(ourusername.id, usernameforsearch.id, "pending")
    if request != nil
      erb :addfriend
    end
  else
    @userfound = "Sorry, User was not found"
    erb :profile
  end
end


get '/listinvites' do
  usernameforsearch = Moodeo.db.get_user_by_username(@@username)
  invites = Moodeo.db.get_all_friend_requests_by_user_id(usernameforsearch.id)
  puts "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
  puts invites
  erb :listinvites
end


# get '/main' do
#   erb :main
# end
