require './spec/spec_helper.rb'

describe 'Sessions' do
  it "initializes with a unique session id" do
   User.class_variable_set :@@counter, 0
   user = User.new("hi", "abc", "123")
   session = Session.new(user.id)
   expect(session.user_id).to eq(user.id)
  end
end
