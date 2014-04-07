require_relative './lib/moodeo.rb'
require 'sinatra'
require 'rubygems'
require 'pry-debugger'

Moodeo.db_name = 'moodeo.db'

set :bind, '0.0.0.0'

get '/' do
  erb :home
end

get '/signin' do
  erb :signin
end

post '/signin' do
  result = Moodeo::SignIn.run(:username => params[:username], :password => params[:password])
  if result.success?
    @usernamedisplay = params[:username]
    erb :home
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


# get '/home' do
#   erb :home
# end
