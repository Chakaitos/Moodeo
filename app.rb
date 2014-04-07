require_relative './lib/moodeo.rb'
require 'sinatra'
require 'rubygems'

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
    erb :home
  elsif result.error == :username_not_found
    @message = "Sorry, username is not found"
    erb :signin
  elsif result.error == :password_not_correct
    @message = "Sorry, password is not correct. Try again"
    erb :signin
  end
end

get '/signup' do
  @name = params[:name]
  @username = params[:username]
  @password = params[:password]
  erb :signup
end

# get '/home' do
#   erb :home
# end
