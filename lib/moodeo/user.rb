class User
 	attr_accessor :name, :password, :username, :id
 	@@counter = 0

  def initialize(name,username,password)
    @name = name
    @username = username
    @password = password
    @@counter += 1
    @id = @@counter
    @invites = []
  end
end
