module Moodeo
  class InviteRequest
    attr_accessor :id, :status, :inviter_id, :invitee_id
    @@counter = 0
    def initialize (inviter_id, invitee_id, status = "pending")
      @@counter+=1
      @id = @@counter
      @status = status
      @inviter_id = inviter_id
      @invitee_id = invitee_id
    end
  end
end