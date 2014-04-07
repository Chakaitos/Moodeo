module Moodeo
  class RequestFriend < UseCase
    def run(inputs)
      @db = Moodeo.db

      session_key = inputs[:session_id]
      invitee_id = inputs[:invitee_id]
      inviter_id = @db.get_user_by_session(session_key)
      # binding.pry
      inviter = @db.get_user(inviter_id)
      invitee = @db.get_user(invitee_id)
      status = "pending"
      # binding.pry
      # inviter_user = @db.get_user(inviter)

      session = @db.get_session(inputs[:session_id])
      return failure(:session_not_found) if session.nil?
      return failure(:invitee_not_found) if invitee == nil

      # binding.pry
      invite = @db.friend_request(inviter.id, invitee.id, status)

      success(:id => invite.id, :invitee_id => invitee.id, :inviter_id => inviter.id)
    end
  end
end
