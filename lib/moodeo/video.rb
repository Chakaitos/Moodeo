class Video
 	attr_accessor :name, :genre, :url, :id
 	@@counter = 0
 	
  def initialize(name, genre, url)
    @name = name
    @genre = genre
    @url = url
    @@counter += 1
    @id = @@counter
  end
end