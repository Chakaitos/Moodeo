require_relative './lib/moodeo.rb'
require 'sinatra'

set :bind, '0.0.0.0'

get '/signin' do
  @test = params[:username]
  @username =
  erb :signin
end

get '/signup' do
  @name = params[:name]
  @username = params[:username]
  @password = params[:password]
  @password2 = params[:password2]
  erb :signup
end
