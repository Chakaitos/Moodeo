require 'ostruct'

module Moodeo
 class UseCase
     # Convenience method that lets us call `.run` directly on the class
     def self.run(inputs)
       self.new.run(inputs)
     end

     def failure(error_sym, data={})
       UseCaseFailure.new(data.merge(:error => error_sym))
       # UserCaseFailure.new({:error => :name_taken})
     end

     def success(data={})
       UseCaseSuccess.new(data)
     end
   end

   class UseCaseFailure < OpenStruct
     def success?
       false
     end
     def error?
       true
     end
   end

   class UseCaseSuccess < OpenStruct
     def success?
       true
     end
     def error?
       false
     end
   end
 end
