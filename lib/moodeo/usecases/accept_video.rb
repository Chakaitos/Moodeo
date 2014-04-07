module Moodeo
  class AcceptVideo
    def run (inputs)
      @db = Moodeo.db
      session = @db.get_session(inputs[:session_id])
      return failure(:session_not_found) if session.nil?

      request = @db.get_video_request(inputs[:invite_id])
      return failure(:invite_not_found) if invite.nil?

      user_id = @db.get_user_by_session(session.id)
      return failure(:user_not_invited) if request.invitee_id != user_id

      user1 = @db.get_user(request.inviter_id)
      user2 = @db.get_user(request.invitee_id)
      video_session = @db.create_video_session(user1.id, user2.id)

      success :video_session => video_session
    end
  end
end
