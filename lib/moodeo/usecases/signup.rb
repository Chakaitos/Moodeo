module Moodeo
  class SignUp < UseCase
    def run(inputs)
      @db = Moodeo.db

      name = inputs[:name]
      username = inputs[:username]
      return failure(:username_taken) if Moodeo.db.get_user_by_username(username) != nil
      password = inputs[:password]
      return failure(:weak_password) if password.length < 5
      password2 = inputs[:password2]
      return failure(:not_matching_passwords) if password !== password2

      user = @db.create_user(name, username, password)

      success :user => user
    end
  end
end
