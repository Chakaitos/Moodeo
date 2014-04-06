require './spec/spec_helper'

describe 'user' do
 it "initializes a user with a name,username,and password" do

   user = User.new("jon","123","abc")
   expect(user.name).to eq('jon')
 end
end
