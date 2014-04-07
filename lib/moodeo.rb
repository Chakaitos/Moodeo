module Moodeo
end

require 'sqlite3'
require_relative 'moodeo/user.rb'
require_relative 'moodeo/database.rb'
require_relative 'moodeo/session.rb'
require_relative 'moodeo/friend_request.rb'
require_relative 'moodeo/friendship.rb'
require_relative 'moodeo/video.rb'
require_relative 'moodeo/invite_request.rb'
require_relative 'moodeo/usecases/usecase.rb'
require_relative 'moodeo/usecases/signin.rb'
require_relative 'moodeo/usecases/signup.rb'
require_relative 'moodeo/usecases/request_friend.rb'
require_relative 'moodeo/usecases/accept_friend.rb'
require_relative 'moodeo/usecases/video_invite.rb'
require_relative 'moodeo/usecases/accept_video.rb'


