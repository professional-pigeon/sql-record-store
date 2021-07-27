require 'rspec'
require 'pg'
require 'album'
require 'song'
require 'pry'

# Shared code for clearing tests between runs and connecting to the DB will also go here.

DB = PG.connect({:dbname => 'record_store_test'})

RSpec.configure do |config|
  config.after(:each) do
    DB.exec("DELETE FROM albums *;")
    DB.exec("DELETE FROM songs *;")
  end
end