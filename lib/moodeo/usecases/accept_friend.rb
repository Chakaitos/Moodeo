module Moodeo
  class AcceptFriend < UseCase
    def run(inputs)
      @db = Moodeo.db
      session = @db.get_session(inputs[:session_id])
      return failure(:session_not_found) if session.nil?

      invite = @db.get_friend_request(inputs[:invite_id])
      # binding.pry
      return failure(:invite_not_found) if invite == nil

      user_id = @db.get_user_by_session(inputs[:session_id])
      return failure(:user_not_invited) if invite.invitee_id != user_id


      user1 = @db.get_user(invite.inviter_id)
      user2 = @db.get_user(invite.invitee_id)
      friendship = @db.create_friendship(user1.id, user2.id)

      success :friendship => friendship
    end
  end
end
