class VideoSession
 	attr_accessor :user1_id, :user2_id, :id, :opentok_id, :token
 	@@counter = 0

  def initialize(user1_id, user2_id, opentok_id, token)
    @user1_id = user1_id
    @user2_id = user2_id
    @@counter += 1
    @id = @@counter
    @opentok_id = opentok_id
    @token = token
  end
end
