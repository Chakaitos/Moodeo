require './lib/moodeo.rb'
require 'pry-debugger'

Moodeo.db_name = 'moodeo-test.db'

RSpec.configure do |config|
config.before(:each) do
  Moodeo.instance_variable_set(:@__db_instance,nil)

  # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
  # NEW: This clears your tables so you get fresh tables for every test
  # Please READ THE METHOD yourself in database.rb
  Moodeo.db.clear_all_records
  # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
  end
end
