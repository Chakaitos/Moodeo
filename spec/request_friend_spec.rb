require './spec/spec_helper.rb'

describe 'FriendRequest' do
  it "initializes with an invitee and and an inviter" do
    user1 = User.new("homer", "bart1", "hey")
    user2 = User.new("marge", "lisa1", "hey")
    invitation = FriendRequest.new(user1.id, user2.id)
    expect(invitation.inviter_id).to eq(user1.id)
    expect(invitation.invitee_id).to eq(user2.id)
    expect(invitation.status).to eq "pending"
  end
end
