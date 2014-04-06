module Moodeo
  class SignIn < UseCase
    def run(inputs)
      @db = Moodeo.db
      @sql_db = Moodeo::DB.new('moodeo.db')

      username = inputs[:username]
      # binding.pry
      user = @db.get_user_by_username(username)

      return failure(:invalid_username) if user == nil
      password = inputs[:password]
      return failure(:invalid_password) if user.password != password

      session = @db.create_session(user.id)
      success :id => session.id, :user_id => user.id
    end
  end
end
