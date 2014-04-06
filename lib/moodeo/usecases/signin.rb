module Moodeo
  class SignIn < UseCase
    def run(inputs)
      @db = Moodeo.db
      @sql_db = Moodeo::DB.new('moodeo.db')

      username = inputs[:username]
      # binding.pry
      user = @sql_db.get_user_by_username(username)

      return failure(:invalid_username) if user == nil
      password = inputs[:password]
      return failure(:invalid_password) if user.password != password

      session = @sql_db.create_session(user.id)
      success :session => session
    end
  end
end
