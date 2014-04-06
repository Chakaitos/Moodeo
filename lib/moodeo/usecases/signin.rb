module Moodeo
  class SignIn < UseCase
    def run(inputs)
      @db = Moodeo.db

      username = inputs[:username]
      user = @db.get_user_by_username(username)

      return failure(:invalid_username) if user == nil
      password = inputs[:password]
      return failure(:invalid_password) if user.password != password

      session = @db.create_session(user.id)
      binding.pry
      success :session_id => session.id, :user_id => user.id
    end
  end
end
