require './spec/spec_helper.rb'

describe 'InviteRequest' do 

  it "initializes with a inviter/invitee id"  do 
      jo = User.new('jo','joe','123')
      mo = User.new('mo','moe','123')
      invite = Moodeo::InviteRequest.new(jo.id, mo.id)
      expect(invite.inviter_id).to eq(jo.id)
      expect(invite.invitee_id).to eq(mo.id)
  end

end