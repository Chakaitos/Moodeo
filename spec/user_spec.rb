require './spec/spec_helper.rb'

describe 'User' do
 it "initializes a user with a name,username,and password" do

   user = User.new("jon","jon123","abc")
   expect(user.name).to eq('jon')
   expect(user.username).to eq('jon123')
   expect(user.password).to eq('abc')
 end
end
