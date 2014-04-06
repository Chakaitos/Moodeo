require 'sqlite3'

class Session
attr_reader :id, :user_id
 @@counter = 0
   def initialize(user_id)
    @@counter += 1
    @id = @@counter
    @user_id = user_id
   end
end
