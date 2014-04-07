require './spec/spec_helper.rb'

describe 'Friendship' do
  it "initializes with an invitee and and an inviter" do
    user1 = User.new("homer", "bart1", "hey")
    user2 = User.new("marge", "lisa1", "hey")
    friendship = Friendship.new(user1.id, user2.id)
    expect(friendship.inviter_id).to eq(user1.id)
    expect(friendship.invitee_id).to eq(user2.id)
  end
end