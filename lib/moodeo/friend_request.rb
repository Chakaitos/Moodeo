class FriendRequest
  attr_accessor :id, :inviter_id, :invitee_id, :status
  @@counter = 0
  def initialize(inviter_id, invitee_id)
    @@counter += 1
    @id = @@counter
    @inviter_id = inviter_id
    @invitee_id = invitee_id
    @status = 'pending'
  end
end
