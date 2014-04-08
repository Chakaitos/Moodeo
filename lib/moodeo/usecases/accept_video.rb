require 'opentok'

module Moodeo
  class AcceptVideo < UseCase
    def run (inputs)
      @db = Moodeo.db
      invite_id = inputs[:invite_id]
      session_id = inputs[:session_id]
      session = @db.get_session(session_id)
      return failure(:session_not_found) if session.nil?

      request = @db.get_video_request(invite_id)
      return failure(:invite_not_found) if request == nil

      user_id = @db.get_user_by_session(session.id)
      # binding.pry
      # return failure(:user_not_invited) if request.invitee_id == user_id

      user1 = @db.get_user(request.inviter_id)
      user2 = @db.get_user(request.invitee_id)

      # OpenTok Session
      api_key = '44722822'
      api_secret = 'cd008912cf564662b8dcd3016f27968506f1300b'
      opentok_sdk = OpenTok::OpenTokSDK.new api_key, api_secret
      session = opentok_sdk.create_session
      opentok_id = session.session_id
      # End of OpenTok Session

      # OpenTok Token For User
      token = opentok_sdk.generate_token :session_id => opentok_id
      # End of OpenTok Token

      video_session = @db.create_video_session(user1.id, user2.id, opentok_id, token)
      success :id => video_session.id, :inviter_id => video_session.user1_id, :invitee_id => video_session.user2_id, :opentok_id => opentok_id, :token => token


    end
  end
end
