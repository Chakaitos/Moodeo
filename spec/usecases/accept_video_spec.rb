require './spec/spec_helper.rb'

describe Moodeo::AcceptVideo do
  before do
    @db = Moodeo.db
    @user1 = @db.create_user("Drew","123abc", "123456")
    @user2 = @db.create_user("Chris","123abc", "123456")
    @session = @db.create_session(@user1.id)
    @invite = @db.friend_request(@user1.id, @user2.id, "pending")
  end


  # Errors
  it "will return an error if the invite id does not exist" do
    result = subject.run({ :session_id => @session.id, :invite_id => 509 })
    expect(result.error).to eq(:invite_not_found)
    expect(result.error?).to eq(true)
  end

 it "will return an error if the user is not logged in" do
    # invite = @db.friend_request(@user2.id, @user1.id, "pending")
    result = subject.run({ :session_id => 2354, :invitee_id => @invite.id })
    expect(result.error).to eq(:session_not_found)
    expect(result.error?).to eq(true)
  end