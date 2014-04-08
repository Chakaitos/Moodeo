require_relative './lib/moodeo.rb'
require 'sinatra'
require 'rubygems'
require 'pry-debugger'
require 'opentok'

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
  @invites_count = @invites.count

  @video_invites = Moodeo.db.show_all_video_requests_by_user(usernameforsearch.id)
  @video_invites_count = @video_invites.count


  puts "heres the Id!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
  puts usernameforsearch.id
  puts "These are freinds!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
  @friends = Moodeo.db.get_friendship(usernameforsearch.id)

  puts @friends


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
  @friends = Moodeo.db.get_friendship(usernameforsearch.id)
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
  @friends = Moodeo.db.get_friendship(usernameforsearch.id)
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
  @username = session[:username]
  usernameforsearch = Moodeo.db.get_user_by_username(params[:user2])
  ourusername = Moodeo.db.get_user_by_username(@username)
  @friends = Moodeo.db.get_friendship(usernameforsearch.id)
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

get '/invitevideo/:user2' do
  @username = session[:username]
  usernameforsearch = Moodeo.db.get_user_by_username(params[:user2])
  ourusername = Moodeo.db.get_user_by_username(@username)
  @friends = Moodeo.db.get_friendship(usernameforsearch.id)
  if usernameforsearch != nil
    request = Moodeo.db.video_request(ourusername.id, usernameforsearch.id, "pending")
    if request != nil


      # OpenTok Session
      api_key = '44722822'
      api_secret = 'cd008912cf564662b8dcd3016f27968506f1300b'
      opentok_sdk = OpenTok::OpenTokSDK.new api_key, api_secret
      session = opentok_sdk.create_session
      @opentok_id = session.session_id


      # OpenTok Token For User
      @token = opentok_sdk.generate_token :session_id => @opentok_id
      # End of OpenTok Token

      puts "HERES THE OPENTOK BEING CREATED"
      puts @opentok_id
      puts "Then THE TOKEN"
      puts @token
      # End of OpenTok Session


      create_video_session = Moodeo.db.create_video_session(ourusername.id, usernameforsearch.id, @opentok_id, @token)
      puts "HERES THE CREATED VIDEO SESSION *********************************"
      puts create_video_session
      erb :connectedvideo
    end
  else
    erb :main
  end
end


get '/acceptvideoinvite/:user2' do
  @username = session[:username]
  usernameforsearch = Moodeo.db.get_user_by_username(@username)
  ouruser_id = usernameforsearch.id
  buddy = params[:user2]
  buddytosearch = Moodeo.db.get_user_by_username(buddy)
  @friends = Moodeo.db.get_friendship(usernameforsearch.id)


  get_video_session1 = Moodeo.db.get_video_session_by_users(buddytosearch.id, usernameforsearch.id)
  puts '*********************************************************************************'
  puts get_video_session1
  puts '*********************************************************************************'
  @opentok_id = get_video_session1.token
  @token = get_video_session1.opentok_id
  puts "Heres opentok!"
  puts @opentok_id
  puts "Heres the token"
  puts @token
  erb :connectedvideo
end


get '/listinvites' do
  @username = session[:username]
  usernameforsearch = Moodeo.db.get_user_by_username(session[:username])
  @invites = Moodeo.db.get_all_friend_requests_by_user_id(usernameforsearch.id)
  @invites_count = @invites.count
  @actual_invites = @invites.map do |invite|
    @test = invite.inviter_id
    @inviter = Moodeo.db.get_user(@test)
    @inviter_name = @inviter.username
  end
  erb :listinvites
end


get '/listvideoinvites' do
  @username = session[:username]
  usernameforsearch = Moodeo.db.get_user_by_username(session[:username])
  @videoinvites = Moodeo.db.show_all_video_requests_by_user(usernameforsearch.id)
  @invites_count = @videoinvites.count
  @actual_video_invites = @videoinvites.map do |invite|
    @test = invite.inviter_id
    @inviter = Moodeo.db.get_user(@test)
    @inviter_name = @inviter.username
  end
  erb :listvideoinvites
end

get '/acceptfriend/:usernametoadd' do
  @username = session[:username]
  usernameforsearch = Moodeo.db.get_user_by_username(session[:username])
  ouruser_id = usernameforsearch.id
  buddy = params[:usernametoadd]
  buddytosearch = Moodeo.db.get_user_by_username(buddy)
  create_friend = Moodeo.db.create_friendship(ouruser_id, buddytosearch.id)
  @friends = Moodeo.db.get_friendship(usernameforsearch.id)
  erb :main
end

get "/signout" do
  session.clear
  erb :home
end


# get '/main' do
#   erb :main
# end
