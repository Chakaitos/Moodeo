require './spec/spec_helper.rb'

describe 'VideoSession' do

  it "initializes with a user1/user2 id"  do
    jo = User.new('jo','joe','123')
    mo = User.new('mo','moe','123')
    opentok_id = "someshit"
    token = "somemoreshit"
    session = VideoSession.new(jo.id, mo.id, opentok_id, token)
    expect(session.user1_id).to eq(jo.id)
    expect(session.user2_id).to eq(mo.id)
  end
end
