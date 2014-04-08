require './spec/spec_helper.rb'

describe 'Video' do
  it "initializes a video with a name, genre, and url" do
    video = Video.new("Drew eating BBQ", "Funny", "www.youtube.com/drew-eating-bbq")
    
    expect(video.name).to eq('Drew eating BBQ')
    expect(video.genre).to eq('Funny')
    expect(video.url).to eq('www.youtube.com/drew-eating-bbq')
  end
end