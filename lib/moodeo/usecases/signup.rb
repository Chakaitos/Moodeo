module Moodeo
  class SignUp < UseCase
    def run(inputs)
      @db = Moodeo.db

      name = inputs[:name]
      username = inputs[:username]
      return failure(:username_taken) if @db.get_user_by_username(username) != nil
      password = inputs[:password]
      return failure(:weak_password) if password.length < 5

      user = @db.create_user(name, username, password)

      success :user => user
    end
  end
end
