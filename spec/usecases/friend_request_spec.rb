require './spec/spec_helper.rb'

describe Moodeo::RequestFriend do
  before do
    @db = Moodeo.db
    @user1 = @db.create_user("Drew","1234","heyhey")
    @user2 = @db.create_user("Jose","1234","heyhey")
  end

  it "returns error if invitee does not exist" do
    session = @db.create_session(@user1.id)
    result = subject.run({ :session_id => session.id, :invitee_id => 6000})
    expect(result.error).to eq(:invitee_not_found)
  end

  it "works" do
    session = @db.create_session(@user1.id)
    result = subject.run({ :session_id => session.id, :invitee_id => @user2.id})
    expect(result.success?).to eq(true)
  end
end
