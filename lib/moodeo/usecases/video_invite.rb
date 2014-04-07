module Moodeo
  class VideoInvite < UseCase
    def run(inputs)
      @db = Moodeo.db

      session_key = inputs[:session_id]
      invitee_id = inputs[:invitee_id]
      inviter_id = @db.get_user_by_session(session_key)

      inviter = @db.get_user(inviter_id)
      invitee = @db.get_user(invitee_id)
      status = "pending"

      session = @db.get_session(session_key)
      return failure(:session_not_found) if session.nil?
      return failure(:invitee_not_found) if invitee == nil

      video_request = @db.video_request(inviter_id,invitee_id,status)

      success :id => video_request.id, :inviter_id => inviter_id, :invitee_id => invitee_id
    end
  end
end